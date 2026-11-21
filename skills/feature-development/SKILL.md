---
name: feature-development
description: Guide an explicitly requested, human-in-the-loop feature from requirements through design, implementation, validation, review, and delivery. Use when the user asks to organize or continue an end-to-end feature development workflow, including resuming at a later checkpoint; not for standalone design, unrelated one-off implementation, read-only review, or PR-only work.
---

# Feature Development

Move a feature from intent to validated delivery. The checkpoints are a recommended path, not a
state machine.

## Calibrate The Path

Use the smallest process that protects the outcome, and say what was combined or skipped and why.

- A local, reversible change with no UI, contract, data, permission, or compatibility impact can
  merge requirements and design and use focused validation.
- New user behavior or work across layers gets separate requirements, interaction, design,
  implementation, and validation checkpoints.
- Schema, payment, permission, security, compatibility, or broad UI work is split into
  independently deliverable iterations when that lowers review or rollback risk. An iteration gets
  its own slice only when it has its own observable result, acceptance criteria, and rollback
  boundary.

Judge the actual risks; file counts, story points, or a fixed number of reviewers are no substitute.

Shared checkpoint names, for reporting only:

```text
Requirements -> Interaction -> Design -> Review -> Implementation -> Validation -> Acceptance -> Audit -> Delivery
```

## Checkpoints

- **Requirements.** Agree on the goal, in-scope and out-of-scope behavior, constraints, and
  observable acceptance criteria with the user before design.
- **Interaction.** Settle UI states and flows, or the contract, state transitions, and failure
  behavior of an API, CLI, or job, before designing code. Skip it when there is no interaction
  decision.
- **Design.** Use `implementation-design`. If design exposes a missing or contradictory requirement,
  return to that checkpoint instead of filling the gap with an implementation assumption. Present
  the design and stop.
- **Review.** Give independent reviewers the design or diff and the sources, not your conclusions;
  a reviewer handed a conclusion tends to confirm it. The lead resolves every substantive finding
  and returns changed decisions to the user; reviewer votes do not replace that resolution.
- **Implementation.** Starts only after the user approves the reviewed design.
- **Validation.** Never hide a failure or count an infrastructure failure as a pass. State which
  level the evidence reached (unit, real dependency, real environment) and what remains unverified.
- **Acceptance.** Verify user-visible behavior in a real environment and give the user a short test
  path with expected outcomes. Only the user can confirm that acceptance passed.
- **Audit.** Review the final change for correctness, scope, and cleanliness. Fix, retest, and
  review again; do not deliver with known blocking findings.
- **Delivery.** Authorization to deliver code does not authorize migrating data, deploying, or
  changing production. Record progress from repository evidence (merged changes, passing
  validation), not from conversational claims.

## Handoff

At a useful pause, report the current checkpoint, confirmed decisions, evidence, open risks, and
the next decision needed. Keep the final handoff self-contained.
