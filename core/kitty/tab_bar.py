from kitty.fast_data_types import Screen

from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb, draw_title

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

attention_tab_bg = color_red
attention_tab_fg = color_base
active_tab_bg = color_blue
active_tab_fg = color_base
inactive_tab_bg = color_surface1
inactive_tab_fg = color_subtext0


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_tab_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    screen.cursor.bold = False

    if index == 1:
        screen.cursor.italic = True
        _draw_bubble(
            screen, f"   {tab.session_name} ", color_base, color_peach, left=False
        )
        _draw(screen, " ", 0, 0)
        screen.cursor.italic = False

    fg = inactive_tab_fg
    bg = inactive_tab_bg

    if tab.needs_attention:
        screen.cursor.bold = True
        fg = attention_tab_fg
        bg = attention_tab_bg
    elif tab.is_active:
        screen.cursor.bold = True
        fg = active_tab_fg
        bg = active_tab_bg

    _draw_bubble(screen, f"{tab.title}", fg, bg)
    _draw(screen, " ", 0, 0)

    return screen.cursor.x


def _draw_bubble(screen: Screen, text: str, fg: int, bg: int, left=True, right=True):
    if left:
        _draw(screen, "", bg, color_base)

    _draw(screen, text, fg, bg)

    if right:
        _draw(screen, "", bg, color_base)


def _draw(screen: Screen, text: str, fg: int, bg: int):
    screen.cursor.fg = fg
    screen.cursor.bg = bg
    screen.draw(text)
