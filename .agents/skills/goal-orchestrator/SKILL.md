---
name: goal-orchestrator
description: 运行用户通过 goal/长期目标发起的多阶段任务编排。Use when the user provides a goal objective, epic or phase document path, asks to execute phases/sprints sequentially, or wants Codex to orchestrate a long-running goal with fast-track, epic-planner, deep-thinking, smart-commit, compact/handoff gates.
---

# Goal Orchestrator

用于执行用户通过 goal 命令或长期目标发起的多阶段任务。用户通常只提供一个目标说明、epic 文档路径或 phase 指引路径；本技能负责按阶段推进、读取必要技能、执行门禁、提交并交接上下文。

## 核心原则

- 每次只执行一个 Phase/Sprint；完成并提交后再进入下一个 Phase。
- 不凭记忆使用其他技能；需要某个技能时，先读取对应 `SKILL.md`。
- 目标已预授权常规实现、测试、规约同步、归档和提交；只有会改变业务范围的关键问题才询问用户。
- epic 文档是父级导航，不是实施日志；详细过程放到 fast-track 归档、phase-guide、spec 或测试中。
- 遇到上下文压缩、恢复或新 Phase，重新读取目标文档和本阶段需要的技能文件。

## 技能名称与适用实际

- Fast Track 执行：`fast-track-lead`
- 深度反思：`deep-thinking`
- Epic 更新：`epic-planner`
- 提交推送：`smart-commit`

## Phase 执行流程

1. **接收目标**
   - 读取用户给出的 goal、epic 文档路径、phase-guide 路径或任务说明。
   - 如果路径不完整，从当前仓库内查找对应 `.develop/epic/**/epic.md`。
   - 读取项目根目录和 `.develop/AGENTS.md` 中与规划、代码、测试相关的约束。

2. **选择当前 Phase**
   - 优先执行 `Status: In-Progress` 的 Phase。
   - 若没有 In-Progress，则执行第一个 `Status: Planned` 的 Phase。
   - 若全部 Done，进入最终完成审计。
   - 维护简短 TODO/plan，状态随工作推进更新。

3. **启动 Sprint**
   - 读取 `fast-track-lead` skill。
   - 输出简短 Sprint Contract：本阶段范围、不在范围内、验收标准。
   - 若 fast-track-lead 中要求等待用户确认测试/API 文档，本技能默认视为用户已授权执行与本阶段相关的测试、规约和文档同步；除非会扩大业务范围，否则不要等待。

4. **执行与反思**
   - 修改本 Phase 需要的 spec、代码、测试或文档。
   - 核心修改后读取并执行 `deep-thinking` skill，审查边界、风险和连带影响。
   - 运行本阶段相关的聚焦测试和必要命令检查；项目禁止的命令仍然禁止运行。

5. **归档**
   - 创建 fast-track 归档日志。
   - 归档只写问题、原因、变更清单、反思逻辑，不复制长日志。

6. **更新 epic**
   - 更新前重新读取 `epic-planner` skill。
   - 只更新当前 Phase 的 Progress、必要的跨 Sprint 决策和状态。
   - 不把实现过程、完整命令、失败尝试、测试全文写进 epic。

7. **提交与交接**
   - 读取 `smart-commit`，按其脚本流程提交并推送。
   - 提交后确认工作区干净。
   - 如果环境能执行 `/compact`，提交后执行；不能执行时输出 Phase handoff summary。
   - 继续下一个 Phase 时，重新从步骤 1 读取目标文档和必要技能。

## Epic 更新质量门禁

更新 `epic.md` 前后都要检查是否满足 `epic-planner` 对相关章节的要求。

## 完成审计

所有 Phase 完成后，不要直接宣布结束。逐项确认：

- epic 中所有 Phase 都是 `Status: Done`。
- 每个 Phase 都有 fast-track 归档日志。
- 每个 Phase 都有 commit，并已 push 到当前分支 upstream。
- 相关聚焦测试和命令检查已通过。
- 工作区干净，没有未提交改动。
- 残余风险已写入 epic 或复盘日志。

证据不足时继续补证据；只有全部满足才标记 goal 完成。

## 冲突处理

- 用户目标、系统/开发者指令、项目 `AGENTS.md` 高于本技能。
- 本技能用于 goal 自动执行场景；若其他技能要求常规询问用户，而目标已授权自动推进，则按本技能自动推进。
- 若技能之间出现实质冲突，选择更严格、更能保护代码和业务边界的规则，并在 handoff summary 中说明。
- 不要为了通过当前测试而缩小用户目标；每个改动都必须让原始 goal 的最终状态更真实。
