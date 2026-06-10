---
name: semantic-branch
description: '语义化分支管理技能，用于根据当前任务、对话上下文或工作区改动，快速创建符合 Semantic Branch Naming 规范的新 Git 分支。'
---

# Semantic Branch

用于把当前任务或工作区改动转化为规范分支名，并从最新 `origin/master` 创建新分支。确定性的 Git SOP 交给脚本执行，AI 只负责语义判断和必要的人类确认。

## 分支命名

- 格式：`type/short-description`
- 允许字符：小写英文字母、数字、`/`、`-`
- 禁止：中文、空格、下划线、大写字母
- `short-description` 使用英文 kebab-case，尽量 2-6 个词

`type` 只能使用：

- `feat`：新功能
- `fix`：修复 Bug
- `refactor`：不改变行为的重构
- `docs`：仅文档
- `chore`：构建、工具、维护
- `style`：格式、空白等不影响含义的改动
- `test`：测试新增或修正

## 工作流

1. 运行只读检查脚本：
   `bash {skill目录}/semantic-branch/scripts/inspect-worktree.sh`
2. 根据用户请求、对话上下文、脚本输出的当前分支与文件改动，生成一个候选分支名。
3. 如果存在未提交改动，优先把改动语义纳入命名。不要为了创建分支而修改或清理这些改动。
4. 如果语义不明确，先给出最可能的分支名并简短说明判断依据；只有在风险明显时才询问用户。
5. 运行创建脚本：
   `bash {skill目录}/semantic-branch/scripts/create-semantic-branch.sh <branch-name>`
6. 汇报创建结果，包括最终分支名和当前所在分支。

## 脚本职责

- `inspect-worktree.sh`：只读输出仓库、分支、远端、工作区、暂存区、变更文件和最近提交摘要。
- `create-semantic-branch.sh`：校验分支名，检查本地与远端是否重名，获取最新 `origin/master`，创建并切换到目标分支。

## 安全规则

- 不运行 `git reset --hard`、`git clean`、`git stash`，除非用户明确要求。
- 不覆盖已有分支。若分支已存在，让脚本失败并向用户说明。
- 如果获取 `origin/master` 失败、工作区改动阻止切换，停止并报告原因。
- 只在脚本检查通过后创建分支。

## 示例

- “增加用户登录页面的 UI” -> `feat/user-login-ui`
- “修复支付接口超时的问题” -> `fix/payment-api-timeout`
- “优化核心算法的执行效率，清理冗余代码” -> `refactor/core-algorithm-performance`
