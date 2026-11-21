---
name: defect-fix
description: Fix a reported defect by finding where the existing code is wrong and proving the fix at the point of failure. Use when investigating, planning, implementing, or reviewing a bug fix; not for new features, requirement changes, or refactors that do not fix observed behavior.
---

# Defect Fix

A defect fix rests on two things: the real cause, and proof that the fix corrects exactly that
cause.

## Find The Real Cause

- Answer in one sentence: **where is the existing code wrong?** If you cannot, keep investigating;
  do not plan around it.
- The report's "root cause" and "expected behavior" are leads, not the plan.
- The cause must explain the failure where it happened: why there, why then, and why it stopped
  if it did. Detecting the symptom and bypassing it is not a cause.
- Keep proven and unproven apart.

## Fix The Cause, Not The Symptom

- Correct the wrong code or straighten inconsistent logic. Needing a new module, entry point,
  error code, state, or flow makes it a requirement change: stop and report it.
- Retries, longer timeouts, fallbacks, and hiding the error are symptom treatment. Use them only
  when the problem is proven probabilistic.
- Fix where the cause is; do not work around it in another layer or component.

## Prove It At The Point Of Failure

- Reproduce the reported failure on the unfixed code first.
- The test must assert the reported wrong behavior itself, and fail on unfixed code for that
  reason. A test that passes before and after proves nothing; show it with a mutation instead.
- A symptom that went away (restart, deploy, elapsed time) is not proof.
- State honestly which level the proof reached: unit, real dependency, or the environment where
  the defect was reported.
