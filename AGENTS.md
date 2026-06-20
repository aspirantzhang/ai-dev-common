# 人资运营平台

## 项目介绍

这是一个人资运营平台，用于管理候选人、员工主档、组织岗位、考勤假期、薪酬福利、绩效和员工生命周期流程。
系统最重要的特质是 [数据安全 / 业务准确性 / 可审计性 / 响应速度]。当你在架构或实现上犹豫时，请优先考虑这些特质。
技术栈：Next.js / React / Node.js / TypeScript，后端数据服务可对接 MySQL、Redis 等基础设施。

## 核心知识库

- 模块地图 (Module Map): 详见 `docs/module-map.md`。修改现有代码前，先在这里确认模块边界和职责。
- 影响地图 (Impact Map): 详见 `docs/impact-map.md`。如果你修改了模块 A，必须来这里检查是否需要同步测试模块 B。
- 架构决策 (ADR): 详见 `docs/adr/index.md`。如果遇到看起来不合理的历史设计，先去这里查阅原因。
- 领域语义（Domain）：详见 `docs/domain.md`。业务领域的核心词汇和概念定义。

## Always（永远不妥协）

- 所有用户输入必须校验。
- 接口暴露字段名采用 snake_case，并与公开 API 契约保持一致。
- 涉及薪酬、证件、绩效等敏感数据时，必须先确认权限和数据范围。
- 写操作必须有明确的校验、权限和事务边界。

## Never（永远不允许）

- 禁止在代码中输出或提交任何真实凭证或 Secret。
- 禁止绕开需求直接生成结果，如无法完成时可以明确表示无法完成。
- 禁止直接操作生产数据库或运行面向生产环境的 migration、seed、清理脚本。
- 禁止同时运行多条测试命令。

## 工程规范

- 命名约定 → 遵循 TypeScript / Next.js 约定，并优先使用人资领域语义。
- 代码风格 → `docs/code-style.md`
- 通用字段规则 → `docs/field.md`
- 错误处理 → `docs/errors.md`
- 测试规范 → `write-tests` skill
- 国际化规范 → `i18n` skill
- API 文档生成规范 → `write-api-docs` skill
- 行为与审计日志规范 → `behavior-audit-logging` skill
- 第三方接口集成规范 → `third-party-api-integration` skill

## 工具使用

- 优先使用 `fast-context` mcp 语义搜索 (fast_context_search) → 返回文件 + 行号范围 + grep关键词建议 → `grep` 二次精确搜索 → 定位目标代码。
- 次优先使用 `desktop-commander` mcp 进行文件读取、搜索等 IO 操作。
- 通过运行 bash 的 `date` 命令获取当天日期。
- 本地通过容器开发，要进行命令行操作，需使用 `docker exec {{container}} bash -c "su www-data -c 'your-command'"` 这种格式。
- 使用 mcp 工具 `dbhub - mysql` 来读取指定表的结构 (SHOW CREATE TABLE)
- MCP 使用指引详见 `docs/mcp-tool.md`。
