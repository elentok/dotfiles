from kitty.boss import get_boss
from kitty.constants import appname
from kitty.fast_data_types import Screen
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb

# Cattpuccin:
color_rosewater = as_rgb(0xF5E0DC)
color_flamingo = as_rgb(0xF2CDCD)
color_pink = as_rgb(0xF5C2E7)
color_mauve = as_rgb(0xCBA6F7)
color_red = as_rgb(0xF38BA8)
color_maroon = as_rgb(0xEBA0AC)
color_peach = as_rgb(0xFAB387)
color_yellow = as_rgb(0xF9E2AF)
color_green = as_rgb(0xA6E3A1)
color_teal = as_rgb(0x94E2D5)
color_sky = as_rgb(0x89DCEB)
color_sapphire = as_rgb(0x74C7EC)
color_blue = as_rgb(0x89B4FA)
color_lavender = as_rgb(0xB4BEFE)
color_text = as_rgb(0xCDD6F4)
color_subtext1 = as_rgb(0xBAC2DE)
color_subtext0 = as_rgb(0xA6ADC8)
color_overlay2 = as_rgb(0x9399B2)
color_overlay1 = as_rgb(0x7F849C)
color_overlay0 = as_rgb(0x6C7086)
color_surface2 = as_rgb(0x585B70)
color_surface1 = as_rgb(0x45475A)
color_surface0 = as_rgb(0x313244)
color_base = as_rgb(0x1E1E2E)
color_mantle = as_rgb(0x181825)
color_crust = as_rgb(0x11111B)

SESSION_NAME_MAX_LEN = 15
TAB_TITLE_MAX_LEN = 20

attention_tab_bg = color_red
attention_tab_fg = color_base
active_tab_bg = color_blue
active_tab_fg = color_base
# Agent status is shown via the bubble's text color (the inactive background is
# kept, so it never competes with the blue active bubble).
waiting_tab_fg = color_red
working_tab_fg = color_green
inactive_tab_bg = color_surface1
inactive_tab_fg = color_subtext0

marker_fg = color_overlay0
marker_bg = color_base

# Per-window user var written by `blf kitty set-agent-state` (see blf ADR 0004).
# Values: working | waiting | idle. A tab's status is the most-urgent value across
# its windows; higher rank wins.
AGENT_STATE_VAR = "AGENT_STATE"
_STATUS_RANK = {"waiting": 3, "working": 2, "idle": 1}
WAITING_ICON = ""

# Sliding-window start index, persisted across renders, keyed by os_window_id.
# The window only scrolls when the active tab would fall off an edge.
_window_start: dict[int, int] = {}
# Plan for the current render, keyed by os_window_id. Recomputed on the first
# tab of every pass (kitty runs a layout pass then a real pass, both starting
# at index 1), so it is never stale within a render.
_plan_cache: "dict[int, _Plan | None]" = {}


class _Plan:
    def __init__(
        self,
        positions: dict[int, int],
        start: int,
        end: int,
        hidden_left: int,
        hidden_right: int,
        header_session: str,
        statuses: "dict[int, str | None]",
    ):
        self.positions = positions  # tab_id -> index in the shown-tabs list
        self.start = start
        self.end = end
        self.hidden_left = hidden_left
        self.hidden_right = hidden_right
        self.header_session = header_session
        self.statuses = statuses  # tab_id -> agent status (waiting/working/idle/None)


def _truncate(text: str, max_len: int) -> str:
    if len(text) > max_len:
        return text[:max_len] + "…"
    return text


def _tab_text(
    index: int, session_name: str, title: str, status: "str | None" = None
) -> str:
    sessionless = " " if session_name == "" else ""
    bell = f"{WAITING_ICON} " if status == "waiting" else ""
    return f"{bell}{index} {sessionless}{_truncate(title, TAB_TITLE_MAX_LEN)}"


def _tab_agent_status(tab) -> "str | None":
    # Most-urgent AGENT_STATE across the tab's windows (waiting > working > idle).
    best = None
    best_rank = 0
    for window in tab.windows:
        state = getattr(window, "user_vars", {}).get(AGENT_STATE_VAR)
        rank = _STATUS_RANK.get(state, 0)
        if rank > best_rank:
            best_rank = rank
            best = state
    return best


def _header_text(session_name: str) -> str:
    return f"   {_truncate(session_name, SESSION_NAME_MAX_LEN)} "


def _left_marker_text(n: int) -> str:
    return f" ‹{n} "


def _right_marker_text(n: int) -> str:
    return f" {n}› "


# A tab bubble is: left cap () + text + right cap () + a trailing space.
def _tab_width(text: str) -> int:
    return len(text) + 3


# The header bubble omits the left cap: text + right cap () + a trailing space.
def _header_width(text: str) -> int:
    return len(text) + 2


def _clamp(value: int, lo: int, hi: int) -> int:
    return max(lo, min(value, hi))


def _fit_end(widths: list[int], start: int, budget: int) -> int:
    used = 0
    end = start
    for i in range(start, len(widths)):
        if used + widths[i] <= budget:
            used += widths[i]
            end = i
        else:
            break
    return end


def _compute_plan(os_window_id: int, columns: int) -> "_Plan | None":
    boss = get_boss()
    tm = boss.os_window_map.get(os_window_id) if boss else None
    if tm is None:
        return None

    tabs = list(tm.tabs_to_be_shown_in_tab_bar)
    n = len(tabs)
    if n == 0:
        return None

    active_tab = tm.active_tab
    positions = {t.id: i for i, t in enumerate(tabs)}
    active = 0
    widths: list[int] = []
    statuses: "dict[int, str | None]" = {}
    header_session = ""
    for i, t in enumerate(tabs):
        title = t.name or t.title or appname
        session_name = t.created_in_session_name
        status = _tab_agent_status(t)
        statuses[t.id] = status
        if i == 0:
            header_session = session_name
        if t is active_tab:
            active = i
        widths.append(_tab_width(_tab_text(i + 1, session_name, title, status)))

    budget = columns - _header_width(_header_text(header_session))

    if sum(widths) <= budget:
        # Everything fits: behave like the original, no markers.
        _window_start[os_window_id] = 0
        return _Plan(positions, 0, n - 1, 0, 0, header_session, statuses)

    # Overflowing: conservatively reserve space for both markers plus one cell
    # of slack (so we never fill the last column and trigger kitty's own red
    # overflow "…"). The reserve uses the widest possible count so the actual
    # markers always fit.
    marker_reserve = 2 * (len(str(n)) + 3)
    budget = max(1, budget - marker_reserve - 1)

    start = _clamp(_window_start.get(os_window_id, 0), 0, n - 1)
    if active < start:
        start = active
    end = _fit_end(widths, start, budget)
    if active > end:
        # Active fell off the right edge: walk left from it, filling the budget,
        # so the active tab becomes the rightmost visible one.
        used = widths[active]
        start = active
        i = active - 1
        while i >= 0 and used + widths[i] <= budget:
            used += widths[i]
            start = i
            i -= 1
        end = _fit_end(widths, start, budget)

    _window_start[os_window_id] = start
    return _Plan(positions, start, end, start, n - 1 - end, header_session, statuses)


def draw_tab(
    _draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    _before: int,
    _max_tab_length: int,
    index: int,
    _is_last: bool,
    _extra_data: ExtraData,
) -> int:
    os_window_id = tab.os_window_id

    # Recompute the plan at the start of every pass (kitty calls us for tab 1
    # first in both the layout and the real pass).
    if index == 1:
        _plan_cache[os_window_id] = _compute_plan(os_window_id, screen.columns)
    plan = _plan_cache.get(os_window_id)

    # The session header is pinned to the far left, drawn once, regardless of
    # which tab is scrolled into view.
    if index == 1:
        _draw_header(screen, plan.header_session if plan else tab.session_name)

    if plan is None:
        # No window info available: fall back to drawing every tab.
        return _draw_tab_bubble(screen, tab, index)

    pos = plan.positions.get(tab.tab_id)
    if pos is None:
        # Unknown tab (e.g. the new-tab "+" button): draw it normally.
        return _draw_tab_bubble(screen, tab, index)

    # Left marker, immediately before the first visible tab.
    if pos == plan.start and plan.hidden_left > 0:
        _draw_marker(screen, _left_marker_text(plan.hidden_left))

    if plan.start <= pos <= plan.end:
        _draw_tab_bubble(screen, tab, index, plan.statuses.get(tab.tab_id))
    # Otherwise the tab is outside the window: draw nothing so the cursor does
    # not advance (this also keeps its measured length ~0 during the layout
    # pass, so kitty never injects its own overflow indicator).

    # Right marker, immediately after the last visible tab.
    if pos == plan.end and plan.hidden_right > 0:
        _draw_marker(screen, _right_marker_text(plan.hidden_right))

    return screen.cursor.x


def _draw_tab_bubble(
    screen: Screen, tab: TabBarData, index: int, status: "str | None" = None
) -> int:
    screen.cursor.bold = False
    screen.cursor.italic = False

    fg = inactive_tab_fg
    bg = inactive_tab_bg
    if tab.is_active:
        # The active tab is always blue, even when its agent is waiting/working;
        # the bell below still flags a waiting active tab.
        screen.cursor.bold = True
        fg = active_tab_fg
        bg = active_tab_bg
    elif status == "waiting":
        # Keep the inactive background; only the text (and bell) turns red.
        screen.cursor.bold = True
        fg = waiting_tab_fg
    elif tab.needs_attention:
        screen.cursor.bold = True
        fg = attention_tab_fg
        bg = attention_tab_bg
    elif status == "working":
        fg = working_tab_fg

    sessionless = " " if tab.session_name == "" else ""
    title = _truncate(tab.title, TAB_TITLE_MAX_LEN)
    bell = f"{WAITING_ICON} " if status == "waiting" else ""
    _draw_bubble(screen, f"{bell}{index} {sessionless}{title}", fg, bg)
    _draw(screen, " ", 0, 0)

    return screen.cursor.x


def _draw_header(screen: Screen, session_name: str):
    screen.cursor.bold = False
    screen.cursor.italic = True
    _draw_bubble(screen, _header_text(session_name), color_base, color_peach, left=False)
    _draw(screen, " ", 0, 0)
    screen.cursor.italic = False


def _draw_marker(screen: Screen, text: str):
    screen.cursor.bold = False
    screen.cursor.italic = False
    _draw(screen, text, marker_fg, marker_bg)


def _draw_bubble(
    screen: Screen, text: str, fg: int, bg: int, left: bool = True, right: bool = True
):
    if left:
        _draw(screen, "", bg, color_base)

    _draw(screen, text, fg, bg)

    if right:
        _draw(screen, "", bg, color_base)


def _draw(screen: Screen, text: str, fg: int, bg: int):
    screen.cursor.fg = fg
    screen.cursor.bg = bg
    screen.draw(text)
