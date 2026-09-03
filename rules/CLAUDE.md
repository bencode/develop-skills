# Claude Code 专用规范

## 扩展资源

需要进行 Web/React 代码架构和结构审查时，使用 `web-code-review` skill。该 skill 覆盖纯函数提取、Hook 纪律、依赖方向、重构安全和测试策略等高阶原则。

## Memory Schema Extensions

写入 auto memory 的 `user`、`feedback`、`project`、`reference` 四类记录时，除默认 frontmatter 的 `name`、`description`、`type` 外，增加 `scope` 和 `confidence` 字段，并在正文中记录 `Evidence`：

```markdown
---
name: ...
description: ...
type: feedback
scope: global
confidence: high
---

... 规则正文 ...

**Why:** ...
**How to apply:** ...
**Evidence:**
- 2026-04-19 session: user confirmed X approach works
```

### `scope`

- 跨项目适用的规则使用 `global`
- 仅在特定项目成立的规则使用项目名，例如 `project-a`、`project-b`
- Session 启动时只加载 `scope: global` 和当前项目 scope 的 memory，不加载其他项目的 memory

| 规则类型 | 推荐 scope |
| --- | --- |
| 语言或框架约定 | 项目 scope |
| 文件结构偏好 | 项目 scope |
| 项目错误处理策略 | 项目 scope |
| 安全实践 | `global` |
| 通用工程实践 | `global` |
| 工具使用模式 | `global` |
| Git 实践 | `global` |

### `confidence`

| 取值 | 含义 | 行为 |
| --- | --- | --- |
| `high` | 被多次验证或用户明确确认 | 自动采纳 |
| `medium` | 观察过一两次但未反复验证 | 在相关场景应用，必要时询问 |
| `low` | 初次记录的试探性规则 | 仅作提示，不作为强制要求 |

同一规则被重复印证后可提升 `confidence`；出现反例后降低或删除。

### `Evidence`

每条 Evidence 带日期并说明来源，例如用户纠正、用户确认或观察到的模式，用于审计、回滚和避免无依据规则。

### 迁移

新写的 memory 使用上述字段。现有 memory 在下次修改时补充，不单独批量迁移。
