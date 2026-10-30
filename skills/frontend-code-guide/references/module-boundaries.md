# Module Boundaries

Business ownership and component integration are separate dimensions. The vocabulary below is a
convention for projects that adopt it, not a universal frontend standard. Map equivalent existing
names, such as layouts or composables, before editing. Do not scaffold every directory or create npm
packages for these modules.

## Vocabulary

| Module | Owns |
| --- | --- |
| `app` | Bootstrap, providers, routing and registry assembly |
| `shell` | Navigation, header, sidebar, account menu and content frame |
| `pages` | Route entry points and screen composition |
| `nodes` | Schema pages, menus, route metadata and declarative bindings, when applicable |
| `features/<name>` | A business capability's requests, rules, state, UI and integrations |
| Shared `components` | Ordinary UI reused across features, driven by props and callbacks |
| `core` | HTTP transport, session, authorization, tenant context and persistence infrastructure |
| `utils` | Stateless, side-effect-free functions without domain semantics |
| `config` | Environment configuration, product metadata and static mappings |
| `assets` | Static resources |

Within a feature, `api` owns requests/transport types, `model` owns pure data/rules, hooks or entry
components coordinate state and operations, and `components` owns private UI. A hook without JSX
is still framework-dependent; an API function is still I/O. Neither belongs in a pure rule module.
These are responsibilities, not required subdirectories. For example, `features/orders/use-orders.ts`
coordinates order state; a chart hook stays with the chart capability, not in a global `hooks/` bucket.
Shared UI may have business-themed display types without owning a consumer's business workflow.

```text
app / pages                 -> features, shell, shared capabilities
feature entry / hooks       -> own api/model/UI, core, shared capabilities
feature api                 -> core HTTP, own transport/model contracts
feature pure model          -> pure utilities
feature presentation        -> props/callbacks, shared UI, UI utilities
shell                       -> core, shared UI, configuration
shared UI                   -> utilities, static configuration/assets
core                        -> utilities, configuration
config                      -> utilities
```

Arrows permit dependencies; they do not require wrapper layers. Shared foundations must not import
feature implementations or their types. Shared consumers declare their own contract; features adapt
to it. Cross-feature calls use public contracts, remain acyclic, and follow the project's architecture;
compose independent features at the page/application boundary when no direct dependency is needed.

## When Widget means Schema integration

Apply this section only where the project uses Widget for a Schema-accessible capability. FSD uses
Widgets for a different architectural layer; do not apply this section to that layer by name alone.

| Location | Owns | May depend on |
| --- | --- | --- |
| `features/<name>/widgets` | Feature-specific Schema components/data containers | Own feature logic/UI and shared capabilities |
| Top-level `widgets` | Schema capabilities reused across features | Shared components, core and generic helpers; never features |
| `components` | Ordinary framework UI | Props/callback contracts and UI helpers; not Schema integration entries |

```text
features/orders/widgets -> features/orders/use-orders.ts       allowed
features/orders/widgets -> features/orders/api, model          allowed
features/orders/widgets -> widgets/filter                      allowed
widgets/filter          -> features/orders                     forbidden, including type-only imports
```

Put business-specific Widgets inside their feature, not in a top-level registry directory. The app
composition root registers shared and feature entries. Schema references to registered names are
not reverse source imports. Declarative service bindings can stay in Schema; they do not require a
wrapper feature solely to hold an endpoint URL.

Keep expression evaluation and context/event translation at the Schema entry. A generic integration
may execute a caller-supplied read flow when needed, but cannot select a consuming app's endpoint,
identity or business command. Its pure UI implementation remains request-free.

A shared Schema material may colocate its entries:

```text
widgets/order-list/
  index.tsx       # Ordinary UI
  types.ts        # Display and callback contracts
  schema.tsx      # Only if adaptation is needed

schema.tsx -> index.tsx       allowed
index.tsx  -> schema.tsx      forbidden
```

Consumers may use the exported ordinary component even though its file is under `widgets`. Judge
exports by their contract, not a directory substring. Props mapping belongs to UI integration,
not pure models. Do not split out an adapter when direct registration already works.

## Package boundary

Applications do not import each other's private source; shared packages never import their
consumers. Use public entries and declare direct dependencies, including required peer-provided
runtime/style contracts. A subpath export is an entry in one package, not another package.
Application-specific API contracts and backend persistence types are not shared UI contracts.

Examples: an adequate Schema table stays declarative; a capability-specific dialog stays in its
feature; UI used by two applications belongs in their shared UI package. Move existing code only
within the authorized scope, regardless of how much of the target convention it already follows.
