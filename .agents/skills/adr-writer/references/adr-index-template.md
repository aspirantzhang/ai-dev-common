# ADR 索引模板

如果 `docs/adr/index.md` 不存在，创建它。索引应足够短，方便人和 agent 先读索引，再按需读取相关 ADR。

```markdown
# ADR Index

这是架构决策记录的发现入口。
只阅读与当前变更相关的 ADR，不要默认读取整个 `docs/adr/` 目录。

| ADR | 状态 | 主题 | 适用场景 | 文件 |
|---|---|---|---|---|
| ADR-001 | Accepted | OLTP 主存储使用 MySQL | database, persistence, migrations | [001-use-mysql-for-oltp.md](001-use-mysql-for-oltp.md) |
| ADR-002 | Accepted | Billing 与 Order UI 隔离 | billing, order, dependency direction | [002-isolate-billing-from-order-ui.md](002-isolate-billing-from-order-ui.md) |
```

## 索引规则

- 每个 ADR 一行。
- `适用场景` 应写成便于搜索的标签或触发情境。
- 状态必须保持最新。
- 不要在索引里粘贴决策推理过程。
- 已被替代的 ADR 仍保留在索引中，并在状态或主题中指向替代它的 ADR。
