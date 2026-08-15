---
name: writing-go
description: Go coding conventions. Use when writing, editing, or reviewing Go code.
---

# Writing Go

See also `idle-cost-audit` for the invariants around timers/polls/subprocesses that keep a
long-running process out of deep idle.

## Goroutines and channels

- **Every goroutine's blocking channel send or receive must be paired with a `select` on a
  `done`/`ctx.Done()` case.** A bare `ch <- v` or `<-ch` with no shutdown escape hatch deadlocks the
  moment nothing is left to read/write the other end — and in `go test`, that surfaces as a
  10-minute package timeout, not a fast, obvious failure. Applies to worker loops, event
  senders/receivers, and any goroutine started with `go func() { ... }()`.
- **Any new persistent/long-lived goroutine needs an explicit shutdown-under-timeout test**: send
  the shutdown signal (close `done`, cancel the context, ...) and assert the goroutine actually
  exits within a short bound (e.g. via a channel close + `select` with a timeout, not a bare
  `time.Sleep` and hope). Don't rely only on happy-path behavior tests to catch a goroutine that
  never exits.
