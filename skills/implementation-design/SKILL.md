---
name: implementation-design
description: Produce an implementation-ready technical design from confirmed requirements and repository context. Use for implementation plans, detailed technical designs, or the Design checkpoint of feature development; not for requirements discovery, visual design, code implementation, or general architecture explanation without a proposed change.
---

# Implementation Design

Turn confirmed requirements into a decision-complete software design. The implementer may choose
local coding details, but must not need to decide behavior, models, core data structures, contracts,
construct boundaries, dependency direction, persistence semantics, or failure behavior.

## Stage Boundary

Assume the goal, scope, observable behavior, and interaction are already confirmed, and use the
repository context established for the task. Do not repeat requirements discovery or restate product
background in the design. If a missing or contradictory upstream decision would materially change
the implementation, stop and return that specific gap to the preceding stage instead of assuming an
answer.

Produce only the design. Do not implement it. Use the user's requested artifact location; otherwise
deliver the complete design in the current conversation without creating a repository document.

## Use Precise Technical Expression

Choose the smallest expression that states each design fact completely and remains understandable
in plain text:

- Prefer the project's native language, type system, Schema, protocol, or DSL.
- Use mathematics or logic for calculations, invariants, guards, and cross-record constraints.
- Use structured programming languages such as Clojure when they express relationships more clearly
  than prose.
- Use precise prose only for responsibilities, design reasons, compatibility constraints, failure
  effects, and material tradeoffs.

Do not translate code, types, Schema, formulas, state transitions, or structured relationships into
duplicated prose. Do not force a notation where it does not improve precision. Avoid illustrative
examples and generic templates that could bias the target design.

The final design must contain dedicated sections for package and module dependencies, software
constructs and dependencies, implementation sequence, validation design, and the final
implementation boundary. Organize models, contracts, runtime semantics, and conditional concerns
around the facts actually affected; do not emit empty or not-applicable sections.

## Package And Module Dependencies

Provide a dedicated package-and-module dependency subsection before construct-level design.

- Use the repository's real package, service, feature, domain, or equivalent boundaries.
- Map each changed boundary to its owning directory, package root, or equivalent physical location.
- Show the affected complete subgraph: changed boundaries and the key existing dependencies needed
  to understand their placement and behavior.
- Cover both static code dependencies and runtime collaboration where they matter.
- State dependency direction, the contract or data carried by each relationship, and whether the
  edge is existing, added, modified, or removed.
- Identify public exports or package manifests that change, and keep external systems distinct from
  modules implemented in the repository.
- When no cross-package edge changes, still identify the owning module and confirm the dependency
  direction the design preserves.

## Software Constructs And Dependencies

Describe the software constructs that realize the change: functions, React components, hooks,
utilities, types, schemas, controllers, services, repositories, adapters, jobs, handlers, or the
project's equivalent units.

- Name every added or changed public or cross-file construct and give its exact target signature.
- Name private constructs whose responsibility, state, data flow, or dependency direction is a
  design decision; leave mechanical callbacks, local variables, and equivalent helper structure to
  implementation.
- Define each construct's responsibility, ownership, inputs, outputs, side effects, and key
  dependencies without line-by-line pseudocode.
- Express relationships among all changed constructs and the key existing constructs needed to
  understand the design. Include direction, interaction kind, relevant contracts or data, and
  whether each dependency is existing, added, modified, or removed.

## Models, Data, And Contracts

When affected, decide and precisely express:

- Domain entities, value objects, identity, lifecycle, state, relationships, cardinality, and
  invariants.
- Persistence models, fields, database types, nullability, defaults, relations, references, delete
  and update behavior, indexes, uniqueness, mappings, and other constraints.
- Core data structures that cross files or processes, are persisted or serialized, carry business
  state, enforce an invariant, control authorization or idempotency, or are shared by constructs.
- API requests and responses, commands and results, event or message payloads, component props,
  form or view models, hook inputs and outputs, and other cross-construct contracts.

Use complete target semantics. Choose a full target definition or an exact change expression based
on which is clearer; do not replace model, field, relationship, or type decisions with prose. For
persistence changes, also define the read scope, write predicates, transaction ownership, atomicity,
and concurrency behavior that affect correctness.

## Runtime Semantics

Specify data flow, control flow, state transitions, core algorithms, side effects, and failure
semantics wherever they determine correctness. For UI work, map the confirmed interaction to
component composition, state ownership, data sources, hooks, effects, and loading, empty, error,
permission, destructive, and recovery states that are actually affected.

Authorization, tenant or data scope, transactions, concurrency, idempotency, retry, timeout,
compatibility, migration, external systems, observability, performance constraints, and resource
lifecycle are conditionally mandatory: express them precisely when affected and omit them entirely
when they are not.

Record only material, non-obvious reasons for choices that affect boundaries, dependencies, models,
contracts, compatibility, or failure behavior. Do not include investigation logs, unresolved option
lists, or a requirements traceability matrix.

## Implementation Sequence

Give the high-level implementation order imposed by dependencies, migrations, generated outputs,
or compatibility. State the verifiable result of each step without turning the design into a
fine-grained task checklist.

## Validation Design

Define proportionate validation for public behavior, material branches, failure semantics, and
safety boundaries. Name added or modified test files in the implementation boundary and use real
repository commands. Do not add tests mechanically for every construct, duplicate guarantees made
by compilers or official validators, or validate structured source through text matching when a
real parser or behavior check exists.

## Implementation Boundary

End the design with one complete annotated directory tree. This tree is the only implementation
file boundary.

- Include every production, test, Schema, migration, configuration, manifest, documentation, and
  generated file to add, modify, or delete.
- Mark each file `[A]`, `[M]`, `[D]`, or `[G]`, then state its responsibility and concrete change.
- Under each file, list the affected constructs and their add, modify, or delete status.
- Keep unchanged reference files and existing dependency nodes out of the tree.
- For generated files whose exact names are not known in advance, give the generation command and
  output directory; add the concrete generated paths to the boundary after generation.

Before completing the design, verify that every affected technical layer is represented, all
construct and dependency relationships close, design-significant models and types are exact, no
material decision remains unresolved, validation matches the actual risks, and the file-construct
tree contains every planned write.

Include the following execution constraints in the final design:

- During implementation or validation, including unit tests, classify each discovered issue against
  the confirmed design scope before changing code. Scope covers behavior, contracts, dependencies,
  and files; an issue in a listed file is not automatically in scope.
- For out-of-scope issues, record the observed problem, evidence, and impact on the current task.
  Do not fix them directly or expand scope merely to make tests pass. Prepare a separate design for
  each such issue and obtain explicit user confirmation before making those changes.
- If an out-of-scope issue blocks the current task, pause the affected work and explain the blocker;
  unaffected work may continue.
- If implementation requires an unlisted file or a contract or dependency change beyond the
  confirmed design, revise the complete design and file boundary and obtain explicit user
  confirmation before making the additional changes.
