# 模块地图模板

创建或重写 `docs/module-map.md` 时使用本模板。最终地图应保持简洁，优先使用一行条目和指向深层文档的链接。

```markdown
# 模块地图

> 本文档是 AI coding agent 和工程师进入代码库前的系统导航入口。它帮助判断业务变更涉及哪些模块、哪些边界不能破、下一步该读哪些文档或搜索哪些代码。
> 它不是文件树、README、ADR 或完整架构说明。

## 使用方式

- 提案和增量规约阶段：用它判断影响范围和必读规约。
- 设计和任务阶段：用它选择代码搜索方向，并校验搜索结果是否处在正确边界内。
- 具体实现细节：使用语义搜索、`rg/grep`、模块子文档和代码本身继续调查。

## 核心业务域

| 模块      | 路径             | 职责                                     | 下一步                                         |
| --------- | ---------------- | ---------------------------------------- | ---------------------------------------------- |
| Order     | `src/order/`     | 管理订单创建、支付、取消、完成等生命周期 | `specs/order/spec.md`, `docs/modules/order.md` |
| Billing   | `src/billing/`   | 管理账单、支付、退款和计费状态           | `specs/billing/spec.md`                        |
| Inventory | `src/inventory/` | 管理库存占用、释放和库存状态             | `specs/inventory/spec.md`                      |

## 关键支撑域

| 模块         | 路径                | 职责                         | 下一步                       |
| ------------ | ------------------- | ---------------------------- | ---------------------------- |
| Auth         | `src/auth/`         | 管理身份、权限、会话和令牌   | `specs/auth/spec.md`         |
| Notification | `src/notification/` | 管理短信、邮件、站内信等通知 | `specs/notification/spec.md` |

## 跨模块硬边界

- Order 可以通过 BillingPort 请求退款，但不得直接修改 Billing 内部状态。
- UI 不得绕过应用服务直接访问持久化层；若项目已有详细分层规则，链接到 `docs/dependency-rules.md`。
- Inventory 不得读取 Order 私有表或 UI 状态；库存变更通过明确接口或事件完成。

## 高风险影响摘要

> 本节只保留少数最高风险的跨模块影响提示。完整变更影响关系见 `docs/impact-map.md`。

### Order cancellation

- **如果修改**: Order cancellation
- **先检查**: Billing, Inventory, Notification
- **原因**: 取消订单会影响退款、库存释放和用户通知

### Payment status

- **如果修改**: Payment status
- **先检查**: Order, Billing
- **原因**: 支付状态可能改变订单流转和计费状态

## 禁区

| 路径         | 原因             | 替代动作                      |
| ------------ | ---------------- | ----------------------------- |
| `generated/` | 自动生成代码     | 修改生成源，例如 OpenAPI spec |
| `legacy/`    | 废弃实现或兼容区 | 先查 ADR 或迁移计划           |
| `vendor/`    | 第三方代码       | 通过依赖升级流程处理          |

## 相关文档

- `docs/dependency-rules.md`（如有）
- `docs/impact-map.md`
- `docs/adr/index.md`
```

可以根据项目调整章节名称，但必须保留这些核心意图：导航、职责、边界、高风险影响摘要、禁区和相关链接。
