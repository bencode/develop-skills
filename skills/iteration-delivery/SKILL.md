---
name: iteration-delivery
description: Guide a human-in-the-loop, GitHub Issue-backed feature iteration from scope alignment through design, implementation, validation, review, and PR. Use when the user explicitly asks to organize or continue an end-to-end delivery iteration; not for standalone explanations, read-only reviews, or PR-only operations.
---

# Iteration Delivery

Keep a feature moving from intent to validated delivery without turning the work into a rigid state
machine. Treat the checkpoints below as a recommended path: combine, omit, or revisit them when the
task's size and risk justify it, and say what was adapted.

## Start From Current Truth

- Inspect the repository, target branch, related Issues, merged PRs, and existing implementation
  before proposing the next step.
- Identify the current checkpoint and preserve completed work. Do not restart the workflow merely
  because this skill was invoked in a later session.
- Distinguish repository facts from assumptions and user decisions. Resolve discoverable facts by
  inspection before asking questions.

## Calibrate The Path

Use the smallest process that protects the outcome:

- A local, reversible change with no UI, contract, data, permission, or compatibility impact can
  combine scope and design, use focused validation, and skip independent design or E2E review.
- New user behavior or work spanning multiple layers usually benefits from separate scope,
  interaction, detailed-design, implementation, and validation checkpoints.
- Schema, payment, permission, security, compatibility, or broad UI work should be split into
  independently deliverable iterations when that reduces review or rollback risk.
- Production data, authorization, and rollout work also needs the relevant domain safeguards; this
  workflow organizes those checks but does not replace them.

Do not use story points, file count, or a fixed number of reviewers as a substitute for judging the
actual risks.

## Checkpoint Vocabulary

Use these exact one-word names when reporting workflow progress:

```text
Framing -> Requirements -> Interaction -> Design -> Review
-> Implementation -> Validation -> Acceptance -> Audit -> Delivery
```

These names are shared vocabulary, not mandatory state transitions. Combine, skip, or revisit
checkpoints as the calibrated path requires, and label each checkpoint with one of these statuses:

- `pending`: work has not started.
- `active`: work is currently in progress.
- `completed`: the checkpoint's outcome is supported by evidence or explicit user confirmation.
- `skipped`: the checkpoint is intentionally not applicable to the calibrated path.
- `blocked`: progress requires a named decision, dependency, or authorization.
- `revisiting`: new information or a finding reopened an earlier checkpoint.

State why a checkpoint was skipped, blocked, or revisited.

In non-English conversations, retain the canonical English checkpoint and status on first use and
add a short localized explanation, for example `Requirements (<localized meaning>) - active
(<localized meaning>)`. Continue the surrounding discussion in the user's language.

## Recommended Checkpoints

### Framing

- Use an existing umbrella Issue as the outcome and progress record when one exists.
- When GitHub tracking is requested and no suitable umbrella Issue exists, propose one before
  creating it.
- Create a sub-iteration Issue only when the slice has its own observable result, acceptance
  criteria, and PR or rollback boundary. A small outcome can remain one Issue.
- Record progress from repository evidence such as merged PRs and passing validation, not from
  conversational claims.
- GitHub writes require authorization in the current task. Without it, draft the proposed Issue or
  update instead of publishing it.

### Requirements

Establish the goal, audience, current behavior, in-scope and out-of-scope behavior, constraints, and
observable acceptance criteria. Discuss material ambiguities with the user and reach agreement
before detailed implementation design.

Use brainstorming here to explore product goals, scenarios, and boundaries. Brainstorming is an
activity within `Requirements`, not a separate checkpoint.

### Interaction

- For UI work, settle information hierarchy, entry points, primary actions, loading, empty, error,
  permission, destructive, and recovery states before designing the code.
- For APIs, CLIs, jobs, or integrations, treat the request/response contract, state transitions,
  retries, failures, and compatibility behavior as the interaction.
- Skip a separate interaction artifact when the change has no meaningful interaction decision.

### Design

- Trace every actually affected technical layer and name the concrete files to add, modify, or
  delete. The final file list is the implementation boundary.
- Specify public contracts, data flow, state and failure semantics, compatibility constraints,
  migrations or generated outputs, and proportionate test coverage.
- For compatibility work, enumerate the affected entry points, authentication, requests, status and
  error semantics, and response shapes instead of treating compatibility as one generic claim.
- Ask the user to review decisions that affect product behavior or scope. Do not implement while a
  material decision is unresolved.

### Review

Use independent reviewers when distinct perspectives add useful confidence. Assign non-overlapping
lenses such as requirement fit, architecture and ownership, compatibility and security, or testing
and operability. The lead agent resolves substantive findings, revises the design, and returns
changed decisions to the user; reviewer votes do not replace that resolution. For a simple change
or when delegation is unavailable, perform and disclose a structured self-review.

### Implementation

- Begin implementation only after the user authorizes the reviewed plan.
- Default to a dedicated worktree based on the latest target branch. One independently deliverable
  iteration normally maps to one branch, worktree, and PR.
- Reuse an existing clean, same-scope worktree or the current checkout only when the user requests
  it or repository guidance permits it.
- Preserve unrelated changes. If implementation requires a file outside the approved boundary,
  stop, update the design and complete file list, and obtain confirmation before continuing.

### Validation

- Run the narrowest meaningful checks first, followed by broader regression checks warranted by
  the affected boundary.
- Use an independent test or QA agent when it can exercise behavior from a meaningfully different
  perspective. Use browser or E2E testing for real UI journeys and cross-layer state, not as
  ceremony for backend-only or documentation work.
- Record commands, results, relevant environment details, and unresolved coverage gaps. Never hide
  failures or relabel infrastructure failure as a passing result.

### Acceptance

For user-visible or integration-heavy behavior, prepare safe fixtures, start the relevant
environment, and give the user a short test path with expected outcomes. The agent may run the same
flow independently, but only the user can confirm that human acceptance passed. Mark this
checkpoint not applicable when there is no behavior that benefits from manual inspection.

### Audit

- Perform a final correctness and cleanliness review using the most suitable capability available
  in the current environment. Check behavior, contracts, compatibility, scope, code organization,
  and validation evidence; do not hard-code a dependency on one review skill.
- Turn substantive findings into a scoped fix plan, confirm changed decisions, implement, retest,
  and review again. Do not commit known blocking findings.

### Delivery

- Commit, push, create a PR, deploy, or update Issues only when those actions are authorized. A PR
  should state the behavior change, validation evidence, related Issue, and UI evidence when
  applicable.
- Treat authorization to deliver code separately from authorization to migrate data, deploy, or
  mutate a production environment.
- After merge, update iteration progress from the merge result and identify the next independent
  slice. Do not automatically close an umbrella Issue while accepted work remains.

## Communicate Checkpoints

Use the user's current language for conversation and workflow handoffs unless they request another
language. Keep code, documentation, commits, Issues, PRs, and other repository artifacts in the
language required by repository guidance or the artifact's audience.

At a useful pause, report the current checkpoint, confirmed decisions, evidence collected, open
risks, and the next decision or action. Keep the final handoff self-contained even when intermediate
updates already covered the details.
