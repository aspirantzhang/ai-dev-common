# 代码风格

- 使用 TypeScript 编写业务代码，命名优先表达人资业务语义，例如 `employeeStatus`、`payrollPeriod`、`attendanceSummary`。
- 遵循 Clean Code 原则，强调代码自解释，避免无意义的注释；只有在业务规则或取舍不显然时才补充短注释。
- Next.js App Router 的 `route.ts` 只负责 HTTP 层：认证授权、参数解析、schema 校验、调用应用服务和返回响应。
- 复杂业务进入 `src/modules/{domain}/services` 或 `src/modules/{domain}/use-cases`，不要堆在 React 组件或 Route Handler 中。
- 数据访问通过 repository、ORM adapter 或明确的数据访问函数封装；业务层不要散落原始 SQL 或跨模块直接读写表。
- React 组件优先保持展示和交互职责，跨页面复用的业务状态放到 feature hook 或 service client 中。
- API 路由命名与设计遵循 RESTful 语义；创建、更新、删除等写操作必须有清晰的权限、校验和事务边界。
