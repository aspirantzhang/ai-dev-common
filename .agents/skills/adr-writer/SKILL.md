---
name: adr-writer
description: 创建、更新、废弃、替代或评审架构决策记录（Architecture Decision Record, ADR）。当用户要求记录架构决策、技术选型、重要取舍、历史决策、docs/adr 条目、ADR index 更新，或判断某条技术规则应该写入 ADR 还是 AGENTS.md、架构文档、编码规范、业务规约、影响地图时使用。
---

# ADR Writer

使用本 skill 在 `docs/adr/` 下创建简洁、可追溯、适合 AI 编程时代按需读取的 ADR，并维护 `docs/adr/index.md` 作为发现入口。

## 核心原则

把 ADR 当作冷路径的决策史，而不是热路径的执行规则。

- 当前必须遵守的短规则，放到 `AGENTS.md`、`ARCHITECTURE.md`、模块地图或规范文档。
- 业务行为，放到规约。
- 跨模块变更牵连，放到影响地图。
- 有取舍、有替代方案、有历史原因的架构决策，放到 ADR。

## 工作流程

1. 判断是否值得写 ADR。
   只有当决策存在真实取舍、替代方案、跨模块影响、非常规约束、可接受代价或未来重新评估条件时，才写 ADR。若只是普通规范、默认选择或一句话规则，应建议放到更合适的位置。

2. 定位 ADR 目录。
   默认使用 `docs/adr/`。如果用户要求写入仓库且目录不存在，就创建目录。维护 `docs/adr/index.md` 作为 ADR 索引。

3. 确定编号。
   检查已有的 `docs/adr/*.md` 和 `docs/adr/index.md`，使用下一个递增编号，通常为 `001`、`002`。不要复用已废弃或已被替代的编号。

4. 收集决策事实。
   明确背景、最终决策、被放弃的替代方案、适用边界、后果、重新评估触发条件、关联约束。如果核心事实无法安全推断，最多问 1 到 3 个聚焦问题。

5. 起草 ADR。
   起草前读取 `references/adr-template.md`。默认使用中文标题和正文，保留必要英文术语。ADR 应短、清楚、可评审，不写成长篇教程。

6. 更新索引。
   创建或更新 `docs/adr/index.md` 时读取 `references/adr-index-template.md`。索引的目标是帮助人和 agent 按需选择相关 ADR，而不是读完整个 ADR 目录。

7. 添加热路径指针。
   如果 ADR 状态为 Accepted，且用户要求修改仓库，应在相关热路径文档中添加或建议添加短指针，例如 `AGENTS.md`、`ARCHITECTURE.md`、模块地图、依赖规则、影响地图。不要把 ADR 的推理过程复制进去。

8. 自检结果。
   确认 ADR 包含状态、日期、背景、决策、替代方案、适用边界、正负后果、至少一个已接受代价、重新评估触发条件、关联约束，并已覆盖到索引。

## 内容去向判断

当某个内容不确定应放在哪里时，按下表判断：

| 内容                                  | 应放位置                                  |
| ------------------------------------- | ----------------------------------------- |
| 当前必须遵守的一句话规则              | `AGENTS.md`、`ARCHITECTURE.md` 或规范文档 |
| 模块职责、路径、入口导航              | `docs/module-map.md`                      |
| 跨模块硬边界、AI 常走错的禁区         | `docs/module-map.md` 或架构文档           |
| “改 A 可能暗伤 B”的隐性跨模块提醒     | `docs/impact-map.md`                      |
| 架构决策背景和取舍                    | ADR                                       |
| 业务行为、场景、验收规则              | 业务规约                                  |
| 分层 import、依赖方向、可自动检查规则 | 依赖规则文档、linter 或 sensor            |
| 完整测试列表、发布前必跑项            | 测试文档、CI、PR checklist                |
| 函数、类、字段、实现细节              | 代码、模块子文档或注释                    |

## 文件命名

使用：

```text
docs/adr/NNN-short-decision-slug.md
```

示例：

```text
docs/adr/001-use-mysql-for-oltp.md
docs/adr/002-isolate-billing-from-order-ui.md
docs/adr/003-replace-rest-bff-with-graphql-gateway.md
```
