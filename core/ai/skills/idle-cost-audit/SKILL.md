---
name: idle-cost-audit
description:
  Audit a TUI/CLI app for battery/CPU cost while idle. Use when asked why an app is burning
  battery or CPU while sitting untouched, or when reviewing code that adds a periodic tick,
  poll, or subprocess call.
---

# Idle Cost Audit

Find and fix the periodic work that keeps an otherwise-idle process off of deep sleep. Written from
a real audit (gx's `idle-cost` epic) that found seven such sources in one TUI and fixed six of them;
before/after numbers below are from that audit.

## Invariants

Rules that, if followed while writing the code, would have prevented every finding below:

- **No unconditional periodic work.** A timer/ticker that fires regardless of app state is a battery
  cost by construction. Every periodic callback needs a reason to still be running each time it
  fires.
- **A repeating tick must be gated on an active job and must stop when that job ends.** Spinners,
  polls, and progress ticks should rearm only `if running { return tickCmd }`, never
  unconditionally. A dialog left open after its job finishes (failed/waiting-for-input) is the
  common miss — the job ended, but nothing told the tick to stop.
- **Cap the render frame rate rather than accepting a framework default.** A 60 Hz renderer ticker
  is often the entire idle floor, independent of anything the app itself computes. Pick a rate the
  eye can't tell apart from 60 (15–20 Hz is invisible for anything without animation) and set it at
  every place a render loop is constructed — ideally through one shared constructor so a new call
  site can't forget it.
- **Never spawn a subprocess on a path that repeats on a timer.** A subprocess is orders of
  magnitude more expensive than in-process work (tens of ms of fork/exec vs. sub-ms), and a call
  that's cheap once becomes the dominant cost once it's on a 1–2s loop. Resolve/cache the result
  once instead of re-deriving it on every tick.
- **A poll that exists as a correctness backstop should be slow, and should say so.** If the real
  update path is event-driven (a filesystem watch, a push notification), the remaining poll is only
  there to catch what the event source might miss — it should run on the order of tens of seconds,
  and a comment or name should make clear it's a backstop, not the primary path, so nobody "fixes"
  it back down to 1–2s under the impression it's load-bearing.
- **Optimize wakeup rate, not just CPU%.** A cheap-but-frequent timer (say, 1% CPU spent in 1ms
  bursts every 100ms) reads as negligible on a CPU% graph but is what actually keeps a CPU package
  out of deep-idle power states — the wakeup itself has a fixed energy cost independent of how much
  work it does once awake. When judging whether a periodic source matters, ask "how often does this
  wake the process" before "how much CPU% does this cost."

## Method

The procedure that found all seven issues in the reference audit, in order:

1. **Run the app under a pty, not your own foreground pane.** `script -q /dev/null <cmd>` (or
   `expect`/`tmux new-session` for something needing keystrokes), backgrounded, output redirected to
   a file. A full-screen TUI in your own terminal blocks you from running the next measurement
   command, and if you're an unattended agent it reads as a hung pane. Drive it to the tab/state you
   need with piped keystrokes, then leave it untouched — "idle" means untouched, not merely running.

2. **Sample accumulated CPU time with `ps -o time= -p <pid>`, not instantaneous `top`.** Read the
   value at the start and end of a fixed window (30–90s), and report the delta over the window as a
   percentage. This is the load-bearing measurement: **instantaneous CPU readouts hide a periodic
   cost that fires every couple of seconds** — the process is at 0% between ticks and briefly spikes
   on each one, and a `top` snapshot has a good chance of landing in the gap and reporting nothing is
   happening. Accumulated time over a window can't miss a periodic cost no matter when you sample.

3. **Take stacks with `sample <pid>`** (macOS; `perf record`/`py-spy`/equivalent elsewhere) while the
   process is idle, to see what's actually running during the wakeups the CPU delta implies. Idle
   sleep shows up as `__psynch_cvwait`/`kevent`/`select` at the top of the stack; anything else
   (render/parse/format calls, `fork`/`os.StartProcess` frames) is real work happening while nothing
   should be.

4. **Detect child-process spawns by polling `ps -ax -o pid=,ppid=,args=` and filtering on the target
   pid as parent**, at a rate faster than the suspected interval (e.g. every 150ms against a
   suspected 2s poll), for the full measurement window, then dedup by pid. A subprocess that lives
   for tens of milliseconds is invisible to a single `ps` snapshot but will always be caught by one
   of several polls across its lifetime — and if it appears more than once, that's a repeating spawn.

5. **A/B a suspected cause with a variant binary, re-measured identically.** Don't reason about
   whether a change will help — build it and compare. Worked example from the reference audit:
   dropping the render ticker from a 60Hz default to 15 fps (via the framework's `WithFPS` option)
   moved idle CPU on the same idle-tab case from 0.57% to 0.12%, a ~5x cut, confirming the render
   ticker (not disk I/O or anything else running) was the dominant cost for that case. Same pty,
   same tab, same window length, same sampling command — only the one variable changed.

6. **Set a numeric acceptance bar up front and report misses honestly**, on all three axes: zero
   subprocesses spawned on a repeating schedule while idle, steady-state timer rate at or below some
   ceiling (20 Hz in the reference audit), and idle CPU% at or below some target. A number that
   misses the bar is a finding, not a failure to hide — record what's still costing rather than
   quietly relaxing the target. In the reference audit, two of four measured cases missed the CPU%
   target even after every known fix landed, because the host wasn't quiescent and one case had a
   self-referential animating UI element; both were recorded plainly rather than waved off.

### Confounds to rule out before trusting a CPU% number

- **Host quiescence.** If other processes are contending for CPU during the measurement, say so and
  mark the CPU% figures as indicative — but don't let it excuse the other two legs of the bar
  (subprocess spawns, timer rate), which are robust to host load and should be reported without
  hedging.
- **Filesystem/event activity from outside the app under test.** A working, debounced file-watch
  reacting to real writes on disk is not a bug — but if something else is writing to the watched
  path during your window, you're measuring that traffic, not the app's idle floor.
- **A live/animating UI element tied to the very session running the measurement** (e.g. a status
  indicator reacting to the measuring process's own presence) can force full repaints every render
  tick instead of hitting a cheap no-op path. This is a real cost for that scenario, but distinguish
  it from a defect in the idle-cost fixes themselves.

## Reference numbers (gx `idle-cost` epic)

| Case | before | after |
| --- | --- | --- |
| Worktrees tab, idle | 0.57% | 0.12% |
| Status tab, idle | 0.47% | 0.08% |
| Tickets tab, idle | 1.03% | 0.58% (missed 0.15% target — busy scratch tree + self-attached toast) |
| Queue tab, epic present, idle | — | 0.45% (same target miss) |

Findings from that audit, generalized as the invariants above: an unconditional 2s poll that shelled
out to 5 subprocesses per tick (subprocess-on-a-timer); a render ticker at the framework's 60 Hz
default (uncapped frame rate); the same poll never backing off even though an event-driven watch
made it redundant (poll-as-backstop should be slow); a refresh loop that silently died on tab switch
(a gate that fails open is worse than no gate); a dialog spinner that kept ticking after the job it
was waiting on had already finished (rearm not actually gated on activity); a second subprocess call
riding the same unthrottled poll; and an O(n) deep-equal cache check run on every render regardless
of whether anything changed.
