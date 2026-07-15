---
name: consult
description: Consult a higher-level model about the current activity.
disable-model-invocation: true
---

# Consultation

Create a second-opinion loop around the current activity. Pause execution for the entire loop.

## 1. Frame the consultation

- Use the question supplied with `/consult`.
- For a bare `/consult`, derive the central uncertainty from the current activity and ask the user
  to confirm it before continuing.
- Detect whether the activity uses plain `/grilling` or `/grill-with-docs`; default to plain
  `/grilling` when no originating mode is evident.

Continue once the consultation question is confirmed and the original activity is paused.

## 2. Start the consultant

Start one read-only consultant in a fresh context with access to the current workspace:

- On Claude, request the highest available Opus model.
- On Codex, request the highest available `terra` variant.

Resolve the current model dynamically. When explicit model selection is unsupported, explain the
limitation and ask whether to use the platform-selected model before spawning. Retain the same
consultant identity until the user finalizes or aborts. If continuity becomes unavailable, explain
the loss and ask before starting a replacement with the full consultation record.

Continue once a consultant with a declared model-selection status is active.

## 3. Brief the consultant

Send a compact brief containing:

- the objective and consultation question;
- completed work;
- decisions and rationale;
- rejected alternatives;
- the current plan or diagnosis;
- uncertainties and suspected drift;
- relevant files, diffs, errors, tests, and documentation;
- constraints and user preferences.

Label summarized claims separately from verified evidence. Instruct the consultant to advise and
inspect only: it may read the workspace and run non-mutating diagnostics, while the parent retains
all authority to change state.

Route requests for missing context through the parent. Investigate discoverable facts directly and
ask the user only for genuine decisions or unavailable personal context, one question at a time.
Continue with the same consultant until it has enough context to answer.

## 4. Present the findings

Require each finding to contain:

1. Finding
2. Why it matters
3. Evidence or reasoning
4. Recommended handling
5. Alternatives considered
6. Confidence
7. A concrete decision question

Have the consultant return `no material concerns` when that is its supported conclusion. Show its
complete response once, ordering findings by impact and then dependency.

## 5. Resolve every finding

Run a `/grilling` session over one finding at a time. Preserve `/grill-with-docs` behavior by using
the `/domain-modeling` skill when that was the originating mode.

For each finding:

1. Ask its decision question and include a recommended answer.
2. Record the user's disposition as accepted, rejected, or deferred, with rationale.
3. Send the disposition and rationale to the same consultant.
4. Let the consultant accept it or make one focused challenge.
5. Grill any challenge and record the settled disposition.

A settled finding reopens only when new evidence appears or another resolution changes its premises.
If the consultant reported `no material concerns`, ask whether to accept the clean review or
investigate a specific area more deeply.

Continue until every finding has a settled disposition.

## 6. Finalize or abort

Before finalization, send the consolidated dispositions to the same consultant for a consistency
check. Add only genuinely new concerns created or revealed by the resolutions to the same grilling
loop.

Finalize only after every concern has a disposition and the user explicitly finalizes. Then show a
resolution ledger containing each disposition, the user's rationale, the consultant's final
response, the required change, and remaining risk. Fold accepted decisions into the proposed course
of action and ask the user to confirm before resuming execution.

If the user aborts, stop the consultant, leave the original activity unchanged, and show the
findings and unresolved ledger. Keep the consultation in conversation state by default; write
repository documents only when continuing an existing documentation activity or when the user asks
for a saved report.
