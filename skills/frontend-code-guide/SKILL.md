---
name: frontend-code-guide
description: Implement and review frontend modules, shared UI, package boundaries, and API/server-state flows in projects that explicitly install this skill. Use Schema integration guidance only in Schema-driven projects; not for API documentation alone.
---

# Frontend Code Guide

Follow the project's framework, architecture and API contracts. This skill does not authorize a
migration, new feature, or new package.

## Ownership and dependencies

Before adding or moving modules, inspect their callers, public exports and package manifests. Read
[module boundaries](references/module-boundaries.md) when defining ownership or Schema integration;
map its responsibilities to existing names rather than imposing a directory tree.

```text
application -> shared package       allowed
shared package -> consuming app     forbidden
pure business rules -> UI / I/O     forbidden
```

Organize business code by capability and technical libraries by responsibility. Keep private
implementation, tests and fixtures with their smallest owning module. Purity or framework usage
does not determine shared ownership; features may contain framework components and local pure rules.
Extract only the smallest capability already used by independent consumers through the same
semantics and contract. Keep consumer-specific decisions in local adapters, not shared-module
branches or speculative configuration frameworks.

Feature removal should be localized to its owning directories and explicit registration, routing
and public call-site updates. Do not introduce frameworks solely to achieve removability.
Use public cross-module entries, declare direct dependencies, and avoid cycles. Do not introduce
empty wrappers or mandatory intermediate layers.

## UI and Schema

| Condition | Action |
| --- | --- |
| Existing UI/Schema components express the behavior | Compose them |
| A concrete interaction or lifecycle gap remains | Add only the missing component or adapter |
| A component already meets the registration contract | Register it directly |
| Both ordinary UI and Schema entry points are needed | Keep protocol adaptation outside pure UI |

Pure UI receives props and callbacks; local interaction state is allowed. Application endpoints,
identity, permissions and navigation belong to the consuming application, not shared presentation.
Do not require Schema tooling in projects that do not use it.

## API and state

| Event or contract | Required behavior |
| --- | --- |
| Business command | Use its API contract; do not split an atomic operation into unrelated writes |
| Successful write | Synchronize affected server state using an authoritative response or the project's invalidation/refetch mechanism |
| Status-only response | Do not invent an entity or ID; read affected state when the UI needs it |
| Refresh fails after a successful command | Report refresh failure; do not report the command as failed |
| Read inputs change before completion | Prevent obsolete results from replacing the current result |
| Failure or pending result | Follow the actual error/status contract; provide visible state and recovery |

Keep duplicate-submission protection through the command. Preserve actual idempotency and version
semantics; do not add speculative locks/retries. Optimistic UI must reconcile with authoritative
state and handle failure through the project's existing mechanism.

## Expression and verification

Use project types/Schema for contracts, arrows for dependencies, and transitions or tables for
behavior. Prose supplies rationale and exceptions; do not repeat the structured representation.

Verify changed behavior at its public boundary: data/events for adapters, actual consumers for
shared UI, and mutation/refresh/error paths for server state. Use focused checks. Record existing
architectural deviations without silently expanding the refactor.
