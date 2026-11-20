---
name: defect-fix
description: Fix a reported defect by finding where the existing code is wrong and correcting it, with reproduction and red-green proof. Use when investigating, planning, implementing, or reviewing a bug fix; not for new features, requirement changes, or refactors that do not fix observed behavior.
---

# Defect Fix

A defect fix changes code that is wrong, or straightens existing logic that contradicts itself.
It does not add capability. Every plan, implementation, and review must be able to answer one
question in one sentence: **where is the existing code wrong?**

## 1. Root Cause Gate

Do not propose a fix until the root cause is established.

- Ask first: **does this error occur under normal conditions?** If the system normally handles the
  situation, the report shows an abnormal condition. Find the layer, code location, and condition
  that produces it. A symptom that "always happens for X" usually means X is one visible case of a
  wider cause.
- Treat the report's own "root cause" and "expected behavior" as leads, not as the plan. Reports
  often describe a workaround (detect X, offer a rebuild button) as if it were the cause.
- Follow the real call chain across every repository it crosses until the line that produces the
  wrong result. Splitting a defect by repository leaves each side seeing half of the chain.
- Deliver a one-page root cause before any plan: the failing condition, the code location, the
  evidence chain (code, logs, requests, data), and an explicit list of what is proven and what is
  not. Unproven parts stay labeled as such.

## 2. A Bug Fix Is Not A Feature

- Allowed: correct the wrong code; make inconsistent existing logic consistent; reuse an existing
  rule at the point where it was missing.
- Not allowed as a defect fix: new modules, components, buttons, entry points, error codes, states,
  or user-facing flows. Needing any of these means the work is a requirement change. Stop and
  report it as a separate requirement for the owner to decide.
- Each new file in the plan must be justified as an internal extraction of existing behavior, not
  a new capability.
- When a fix has a side effect (for example, a request now reuses an existing record), match the
  existing behavior of the same rule elsewhere. If matching it requires new behavior, prefer
  documenting the narrow limitation over adding code.

## 3. Fix The Cause, Not The Symptom

- Retries, backoff, longer timeouts, fallbacks, retained stale data, and display-only changes are
  symptom treatment. Use them only when the problem is genuinely probabilistic (real concurrency,
  network jitter) and there is evidence that it is.
- Do not stack a frontend workaround on top of a backend cause that can be fixed.
- Do not add locks, serialization, or coordination for theoretical races. When correctness depends
  on an existing mechanism (an optimistic version check, a unique key), name that mechanism in a
  code comment and state any remaining window honestly.
- Before inventing a pattern, look for the same defect already fixed elsewhere in the codebase and
  reuse that fix.

## 4. Plan

- List every file as added, modified, or deleted, with its responsibility. That list is the
  implementation boundary. Discovering a needed file outside it means stop, re-plan, and confirm.
- State the behavior before and after, the failure semantics, and what is explicitly out of scope.
- Keep the design simple and conventional. A clever implementation is a risk, not an asset.

## 5. Reproduce And Prove

- Reproduce on the unfixed version first. A test counts as red only when it fails because of the
  target behavior on unfixed code. A test that passes before and after the fix is not red-green;
  prove it with a mutation (remove the guard, watch it fail) and say so.
- Save the red and green output as evidence with the exact versions used.
- Compare the full related test suite, type check, and lint against the baseline. Report baseline
  failures as baseline, and claim only that the change adds none.
- When the defect happened in a real environment, verify there too: reproduce on the old build,
  then show the fixed build under the same steps. Record versions, timings, and log excerpts, and
  restore the environment afterwards.

## 6. Review Checklist

Reviewers answer these before anything else:

1. Where was the existing code wrong? If the answer is "it was not wrong, something was missing",
   the change is a feature.
2. List every added module, component, entry point, error code, state, or flow separately.
3. Does the fix treat the cause, or retry, relax, or hide it?
4. Does it conflict with other in-flight fixes touching the same behavior?
5. Are the claimed guarantees backed by the code (and not by an assumed lock or idempotency)?
6. Are red-green proofs genuine, and is the scope exactly the planned file list?

## 7. After Merge

- Verify the observed behavior in the environment where the defect was reported before
  recommending closure. "Should be fixed" or "root cause is elsewhere" is not verification.
- The closure note states the cause, the fix, the verification, and any known limitation.
