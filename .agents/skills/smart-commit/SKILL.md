---
name: smart-commit
description: '自动化 Git 流程：同步当前分支、智能暂存、生成 Conventional Commit message、提交并推送。'
---

# Smart Commit

用于把当前工作区或已暂存改动提交并推送。确定性的 Git SOP 交给脚本执行，AI 只负责根据 staged diff 生成提交信息和汇报结果。

## Commit Message

使用 Conventional Commits：

```text
type: subject

body

footer
```

规则：

- `type` 使用 `feat`、`fix`、`docs`、`style`、`refactor`、`test`、`chore` 之一。
- 不添加 scope。
- 不添加 `Co-Authored-By`。
- subject 使用英文，简短描述本次 staged diff 的真实变化。
- body 和 footer 仅在确有必要时使用。

## 工作流

1. 运行只读检查脚本：
   `bash {skill目录}/smart-commit/scripts/inspect-commit-state.sh`
2. 运行准备脚本：
   `bash {skill目录}/smart-commit/scripts/prepare-commit.sh`
3. 根据准备脚本输出的 staged diff 生成纯文本 commit message。
4. 将 commit message 写入临时文件，例如 `.git/COMMIT_EDITMSG.smart`。
5. 运行提交并推送脚本：
   `bash {skill目录}/smart-commit/scripts/commit-and-push.sh .git/COMMIT_EDITMSG.smart`
6. 汇报最终结果：分支名、commit hash、push 是否成功。

## 脚本职责

- `inspect-commit-state.sh`：只读输出仓库、分支、upstream、工作区状态、暂存区状态和 diff 统计。
- `prepare-commit.sh`：若暂存区为空则 `git add .`，然后输出 staged diff。
- `commit-and-push.sh`：从 message 文件读取提交信息，执行 `git commit -F`，成功后执行 `git pull --rebase`，最后执行 `git push`。

## 安全规则

- 如果暂存区已有内容，只处理已暂存内容，不自动加入未暂存文件。
- 如果当前分支没有 upstream，停止且不要提交。
- 如果 `git pull --rebase` 失败，立即停止；不要继续推送，并提示用户处理 rebase。
- 如果没有 staged diff，停止并说明没有需要提交的变更。
- 如果 commit 成功但后续 rebase 或 push 失败，明确告诉用户“本地已提交但未推送”。
- 不运行 `git reset --hard`、`git clean`、`git stash`，除非用户明确要求。
