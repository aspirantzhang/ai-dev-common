# AI Dev Common

## Skills

### Git 流程

- [semantic-branch](./.agents/skills/semantic-branch/SKILL.md)：根据任务语义或工作区改动生成规范分支名，并从最新 `origin/master` 创建符合 Semantic Branch Naming 的新分支。
- [smart-commit](./.agents/skills/smart-commit/SKILL.md)：自动完成提交前检查、智能暂存、Conventional Commit 信息生成、提交、rebase 同步和推送。
- [merge-to-test](./.agents/skills/merge-to-test/SKILL.md)：把当前分支合并到 `test` 并推送，流程由脚本保护，冲突只在 `test` 分支上解决，完成后切回原分支。
- [sync-master-to-feature](./.agents/skills/sync-master-to-feature/SKILL.md)：把 `origin/master` 的最新改动合并到当前分支，保持与主分支同步，减少未来合并冲突。
- [branch-sweeper](./.agents/skills/branch-sweeper/SKILL.md)：安全清理当前本地分支，先校验主分支同步和合并状态，再使用非强制删除，避免误删未合并工作。

### 长任务规划与执行

- [epic-planner](./.agents/skills/epic-planner/SKILL.md)：为长期、多 Sprint 任务创建或维护 `epic.md`，保存目标、阶段计划、跨 Sprint 决策和进度摘要。
- [phase-implementation-guide](./.agents/skills/phase-implementation-guide/SKILL.md)：为 epic 的各阶段撰写实施指引，区分已确认规则、代码调查入口、不得破坏行为、风险点和验收方向。
- [goal-orchestrator](./.agents/skills/goal-orchestrator/SKILL.md)：编排长期 goal 的阶段执行，从选择当前 Phase、调用实现/反思/提交技能，到更新 epic 和交接上下文。

### 文档撰写

- [adr-writer](./.agents/skills/adr-writer/SKILL.md)：创建、更新或评审 ADR（架构决策记录），把有取舍和历史原因的架构决策沉淀到 `docs/adr/`，并维护 ADR 索引。
- [impact-map-writer](./.agents/skills/impact-map-writer/SKILL.md)：维护影响地图，记录“改 A 可能暗伤 B”的非显而易见跨模块影响和检查建议。
- [module-map-writer](./.agents/skills/module-map-writer/SKILL.md)：维护模块地图，用短而稳定的方式说明模块职责、入口、硬边界和 AI 容易走错的禁区。
- [user-story-card-writer](./.agents/skills/user-story-card-writer/SKILL.md)：把口语化业务需求整理成用户故事卡，输出背景、用户故事、验收标准、Given-When-Then 场景和待确认事项。
- [qa-acceptance-guide-writer](./.agents/skills/qa-acceptance-guide-writer/SKILL.md)：编写面向 QA/UAT 的验收指南，明确测试范围、验收步骤、边界场景和证据。

### 质量审查与复盘

- [deep-thinking](./.agents/skills/deep-thinking/SKILL.md)：对既有方案进行审计式复盘，使用逐步推理检查逻辑、边
  界、风险、偏见和落地性，并收敛出更稳妥的最终方案。

```
docs/
    specs/             <- 规约库（业务行为的唯一事实来源）
    adr/               <- ADR（架构决策记录）
    module-map.md      <- 模块地图（模块边界）
    impact-map.md      <- 影响地图（跨模块影响）
```
