---
name: implementation-design
description: Produce an implementation-ready technical design from confirmed requirements and repository context. Use for implementation plans, detailed technical designs, or the Design checkpoint of feature development; not for requirements discovery, visual design, code implementation, or general architecture explanation without a proposed change.
---

# Implementation Design

Turn confirmed requirements into a decision-complete design: the implementer may choose local
coding details, but must not need to decide behavior, models, contracts, construct boundaries,
dependency direction, persistence semantics, or failure behavior.

## Stage Boundary

Assume goal, scope, observable behavior, and interaction are confirmed. Do not repeat requirements
discovery or restate product background. If a missing or contradictory upstream decision would
change the implementation, stop and return that gap instead of guessing.

Produce only the design; do not implement it. Use the user's requested location; otherwise deliver
it in the conversation.

## Expression

Natural language cannot be precise. Express the design in formal languages, which are both rich
and exact:

- Code: the project's language and types, or any programming language that states the design
  clearly (TypeScript, Clojure, Scheme).
- Schema: the project's Schema or DDL (Prisma, PostgreSQL), protocol, or DSL.
- Mathematics and logic: calculations, invariants, guards, cross-record constraints, and state
  changes such as `from --[condition]--> to`.

Whatever one of these can state, state it there. Use prose only for what they cannot carry, such as
the reason for a choice or a tradeoff, and keep it short. Never restate code, Schema, or a formula
in prose. The design is read in a terminal, so everything must read as plain text.

## Design Taste

The taste comes from PEP 20, the Zen of Python: when two designs both satisfy the requirements,
prefer the one it would choose.

- Prefer an explicit call over background machinery. The actor that changes something asks for the
  effect (run a reload, read a file when its value is needed) instead of the system watching for
  changes, keeping caches coherent, or inferring intent.
- Distrust clever mechanisms such as caches, watchers, and elaborate data structures when a plain
  file, a command, or a recomputation does the job.
- If explaining a mechanism needs a list of edge cases, look for a design without them.
- Make failures loud and specific: say what was wrong and how to fix it, and keep the last good
  state instead of guessing.
- Give each capability one obvious name and place.
- Reuse an existing mechanism or rule before adding one.
- A guarantee in the design (lock, isolation level, idempotency, uniqueness) must come from code you
  have read. Name the mechanism and state any remaining window.
- Record a narrow remaining gap as a known limitation instead of adding code to close it.

## Content

Include only what the change affects, sized to the change.

- **Dependencies.** Always name the owning module and the dependency direction kept. When packages,
  services, or ends change, open with an overview tree of the affected directories (unchanged
  siblings allowed for placement; one-line role per file; `← role / who shares it` per subtree),
  then small plain-text graphs per concern: arrows from dependent to dependency, edge labels for what
  is passed or called. Add a reuse table (layer × shared / end-only) when reuse is the point, and
  name what is deliberately not shared.

  ```text
  services/feature-x/                ← rules and data loading (shared by all ends)
  ├── rows.ts                        load order-item × employee rows
  └── report.ts            [M]       add store to report rows
  apps/common/feature-x/schemas.ts [A] API contract (moved from end-b)
  ```

- **Constructs.** Every added or changed cross-file construct with its exact signature,
  responsibility, inputs, outputs, side effects, and dependencies. Name a private construct only
  when its responsibility or data flow is a design decision.
- **Models and contracts.** Exact definitions for anything that crosses files or processes, is
  persisted, carries business state or an invariant, or controls authorization or idempotency. For
  persistence, also the read scope, write predicates, transaction ownership, and concurrency.
- **Runtime semantics.** Data flow, control flow, state transitions, and failure semantics where
  they determine correctness. Authorization, tenant scope, concurrency, idempotency, retry,
  timeout, compatibility, migration, and observability appear only when affected.
- **Implementation sequence.** The order imposed by dependencies, migrations, or compatibility, with
  a verifiable result per step.
- **Validation.** Proportionate to the real risks, with real repository commands.
- **Implementation boundary.** End with one annotated tree of every file to write, marked `[A]`
  added, `[M]` modified, `[D]` deleted, or `[G]` generated, each with its responsibility, concrete
  change, and affected constructs. This tree is the only file boundary.

Record only material, non-obvious reasons. No investigation logs, open option lists, or
traceability matrices.

Before finishing, check that every affected layer is covered, all relationships close, models and
types are exact, no material decision is left open, and the boundary tree contains every planned
write.
