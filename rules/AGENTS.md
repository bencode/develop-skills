# 通用工程规范

## 适用原则

- 本文件定义跨项目默认工程规范；项目级 `AGENTS.md` 可补充项目事实、命令和局部约束
- 当前对话中的用户明确要求优先于本文件；发现规则冲突时，先说明冲突及影响，不自行选择会扩大任务范围的解释

## Agent 工作流

- 默认不使用 Superpowers 系列技能或工作流
- 只有用户在当前对话中明确要求时才使用 Superpowers；若项目级说明要求使用，先向用户说明冲突并取得明确确认
- 除非用户明确要求在当前检出目录操作，否则所有会修改仓库文件的开发任务默认在独立 Git worktree 中进行；仓库主工作目录仅用于只读检查和 worktree 管理，不直接产生改动

## 开发理念

- 偏好函数式编程和简洁代码。将文件超过 200 行、函数超过 40 行视为需要审视的信号，不为满足数字机械拆分代码
- 注释遵循 DRY 原则，不重复代码已经清楚表达的逻辑
- 不允许为了通过 lint 而降低规则要求，应修复实际代码问题
- 禁止过度设计：只实现当前明确需求，不为假设的未来场景增加抽象、扩展点或基础设施
- 并发设计必须基于真实业务场景和明确风险。切忌为了理论竞态引入锁、串行化事务、重试、额外模型或协调机制；若并发操作并非真实可信的业务路径，保持简单实现。对于接口已明确承诺的并发语义（如已有 `version` 乐观锁、支付和订单状态转换），仍须保证实现正确

## 范围控制

- 严格以任务明确授权的目标、范围和当前阶段为边界，不得以“未来可能需要”、追求完整性或顺手优化为由，自行增加功能、抽象、数据结构、状态、接口、工具、重构或测试
- 发现相邻需求或潜在改进时，只说明或记录为后续事项，不纳入当前方案或实现；确需扩大范围时，必须先取得用户明确确认
- 严格区分分析、设计、记录与实现。用户只授权其中某一阶段时，不执行后续阶段的动作

## 设计规范

- 用户要求详细设计或实施方案时，必须细化到模块和具体文件；逐个文件标明新增、修改或删除，并说明该文件承担的职责和具体改动
- 关键改动必须沿实际受影响的技术链路设计到底，不停留在概念描述；只展开实际受影响的层，不机械罗列无改动模块
- 涉及 Prisma 时，明确 Schema 模型、字段、关系和约束，Prisma Client 的读写方式，业务模块的接入方式，以及 Migration 的生成方式
- 实施型设计最后必须列出完整文件范围；该文件列表是实施边界，实施不得修改列表外文件
- Migration、codegen 等工具生成且事前无法确定名称的文件，方案中必须列出生成命令和输出目录；生成后将实际文件补入实施边界
- 发现必须修改范围外文件时，立即停止实施，重新检查影响范围和模块设计，更新完整方案及文件列表；新设计确认后才能继续

## 沟通与表达

### 精确表达优先

- 技术分析、设计和实施方案优先使用可解析、可执行或可验证的精确语言
- 优先使用项目已有的编程语言、Schema、DSL、配置格式和类型系统
- 项目没有对应表达形式时，可以根据问题选择 TypeScript、Clojure、Scheme、数学公式、逻辑谓词、状态转换或结构化表格
- 不为表达方案而无必要地引入项目未使用的实现语言；示例语言不代表要求项目采用该语言
- 表达形式优先级：
  1. 项目原生语言或领域语言
  2. 编程语言、类型系统、Schema、数学或逻辑表达
  3. 结构化表格
  4. 精确自然语言
  5. 日常叙述
- 能用精确语言完整表达的内容，不改写成大段自然语言
- 不使用自然语言逐行复述代码、Schema、公式或状态表已经表达的内容
- 自然语言只补充设计目的、业务原因、兼容约束、失败语义和方案取舍
- 自然语言必须明确主体、条件、动作、结果和例外。避免“相关处理”“适当调整”“支持一下”“视情况处理”等没有判定标准的表达
- 不为形式化而创建无意义的代码、抽象或图表；使用能够准确表达问题的最小形式

### 表达形式示例

数据库结构使用项目采用的 Schema 语言：

```prisma
enum AccountKind {
  standard
  subscription
}

model Account {
  id   Int         @id @default(autoincrement())
  kind AccountKind @default(standard)

  subscription Subscription?
}

model Subscription {
  id        Int     @id @default(autoincrement())
  accountId Int?    @unique
  account   Account? @relation(fields: [accountId], references: [id])
}
```

Schema 无法表达的跨记录约束使用逻辑谓词：

```text
account.kind = subscription ⇔ account.subscription != null
```

API 使用项目语言中的类型和实际 HTTP 契约：

```ts
type CreateBillingInvoiceInput = {
  accountId: number
  planId: number
  transactionId?: number
}

type CreateBillingInvoiceResult = {
  invoiceId: number
}
```

```http
POST /api/billing/invoices
Idempotency-Key: <stable-business-request-id>
```

数值不变量使用数学表达：

```text
transaction.amount = invoice.totalAmount

paidAmount + outstandingAmount = totalAmount

0 < totalAmount ≤ 2_147_483_647
```

状态变化使用转换表达式：

```text
pending --[paidAmount = totalAmount]--> active
active  --[manual deactivation]-------> inactive
```

集合转换可以使用项目语言；以下表达等价，选择与项目一致的一种：

```ts
const activeAccounts = accounts.filter(account => account.status === 'active')
```

```clojure
(filter #(= :active (:status %)) accounts)
```

```scheme
(filter (lambda (account) (eq? 'active (account-status account))) accounts)
```

## 控制流与抽象

- 表达集合转换、筛选和查找时，优先使用 `map`、`filter`、`flatMap`、`reduce`、`find`、`every` 等函数式方法
- 仅在需要顺序异步、明确副作用、提前退出，或命令式控制流明显更清楚时使用 `for...of`
- 避免提前抽象。只有在消除真实复用、集中共享策略，或隐藏调用方不应承担的复杂度时才提取函数或模块
- 不要为了单元测试、单一调用方或可能出现的未来复用增加包装层

## TypeScript/JavaScript

- 优先使用 `type`，而不是 `interface`
- 优先使用具名导出，而不是默认导出
- 不使用 `switch/case`
- 不使用 `any`
- 类型导入必须使用 type-only 语法；独立的 `import type { Foo }` 与混合导入中的 `import { type Foo, value }` 均可
- 禁止通过 `JSON.stringify`、序列化、哈希或字符串拼接等方式构造 React Hook 依赖标识；必须声明真实语义依赖，或者在数据产生处提供稳定引用

## 异常处理

- 禁止隐藏异常，不使用空 `catch`、`.catch(() => {})`、`.catch(() => undefined)` 或用默认值掩盖未知异常
- 捕获异常必须做可观察处理，例如记录日志、`console.error` 或重新抛出
- 预期可忽略的错误必须通过错误类型、错误码或明确条件识别；只处理预期分支，其余错误记录或上抛

## 测试与重构

- 对测试保持克制：只写能捕获明确业务回归或安全风险的必要测试，用最少的高价值测试覆盖核心功能和安全边界
- 测试是一等公民，测试代码与生产代码采用相同的质量标准，避免重复、脆弱或仅验证实现细节的测试
- 优先验证公开接口的可观察行为和跨边界不变量
- 如果仅重命名、移动或等价重构实现就会导致测试失败，而外部行为没有变化，应重新审视该测试是否绑定了实现细节
- 禁止用正则、文本匹配或快照检查 Prisma Schema、Migration、配置文件等源码内容；语法与结构使用官方校验器、编译器或实际 Migration 验证，只有真实数据库行为存在回归风险时才写行为测试
- 不要因为新增了模型、字段、文件或函数就机械补测试；也不要重复测试框架、编译器或官方校验器已经可靠保证的行为
- 重构只调整结构和组织方式，不改变实现语义

## Git

- commit 不添加 “Generated with Claude Code”、“Co-Authored-By: Claude” 或其他代理署名
- 当前环境创建 GitHub PR 或 Issue 时直接使用 `gh` 执行；不要因 `gh auth status` 报告未登录或 token 失效而提前阻塞，也不要切换到浏览器自动化
- `gh` 在沙箱内因本地代理或网络权限失败时，使用允许联网的执行权限重试原命令；只有 `gh pr create` 或 `gh issue create` 本身明确返回认证错误时，才要求用户重新登录
