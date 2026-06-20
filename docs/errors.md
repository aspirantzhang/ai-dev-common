# 错误处理策略

- 服务端错误统一收敛到 `src/server/errors`，按语义区分 `BusinessError`、`ValidationError`、`SystemError`。
- `BusinessError` 用于可预期业务错误，返回 4xx 状态码；`SystemError` 用于非预期系统错误，返回 5xx 状态码。
- Next.js 的 `error.tsx` / `global-error.tsx` 只作为未捕获运行时错误的 UI 兜底，不作为业务错误控制流。
- API Route Handler 应捕获已知错误并转换为 `NextResponse.json()`；未知错误记录日志后返回标准友好的系统错误提示。
- 可选参数：
  - 使用 `logContext` 记录排查上下文，如 `employeeId`、`operatorId`、`requestId`。
  - 使用 `publicMessage` 返回面向用户的安全提示。
  - 使用 `statusCode` 和 `code` 明确 HTTP 状态码与业务错误码。
- 使用示例：
  - `throw BusinessError.of('PAYROLL_RULE_NOT_FOUND', '未找到匹配的薪酬规则', { statusCode: 404, logContext: { employeeType, payrollPeriod } })`
  - `throw SystemError.of('PAYROLL_CALCULATION_FAILED', { cause: error, logContext: { employeeId, payrollPeriod } })`
- 参数校验约定：
  - 查询参数、路径参数格式不合法，返回 HTTP 400。
  - 创建、更新请求体通过基础格式校验但不满足业务规则时，返回 HTTP 422。
  - 认证失败返回 401，权限不足返回 403，资源不存在返回 404。
