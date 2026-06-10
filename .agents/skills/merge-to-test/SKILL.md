---
name: merge-to-test
description: '将当前分支合并到 test 分支并推送，最后切回原分支；Git 流程脚本化，冲突由 AI 在 test 分支上解决。'
---

# Merge To Test

用于把当前工作分支合并到 `test` 分支并推送远端，完成后切回原分支。确定性的 Git SOP 交给脚本执行；如果出现冲突，AI 只在 `test` 分支上读取并解决冲突。

## 核心规则

- 唯一目标是修改 `test` 分支，不修改原分支。
- 禁止把 `test` merge、rebase 或 pull 回原分支。
- 原分支的 HEAD 必须在流程结束后与开始时一致。
- 工作区不干净时停止，不自动 stash、reset 或 clean。
- 冲突只能在 `test` 分支上解决。
- `git pull origin test` 作为默认同步方式；不强制使用 `ff-only`。

## 工作流

1. 运行只读检查脚本：
   `bash {skill目录}/merge-to-test/scripts/inspect-merge-to-test.sh`
2. 运行开始合并脚本：
   `bash {skill目录}/merge-to-test/scripts/start-merge-to-test.sh`
3. 如果输出 `merge_status: clean`，直接运行 finalize 脚本。
4. 如果输出 `merge_status: conflicted`，读取冲突文件，在 `test` 分支上解决冲突并 `git add <file>`。
5. 冲突解决完成后运行 finalize 脚本：
   `bash {skill目录}/merge-to-test/scripts/finalize-merge-to-test.sh`
6. 如果决定放弃冲突解决，运行 abort 脚本：
   `bash {skill目录}/merge-to-test/scripts/abort-merge-to-test.sh`
7. 最终汇报原分支、原 SHA 校验、合并结果、冲突文件和推送结果。

## 脚本职责

- `inspect-merge-to-test.sh`：只读输出当前分支、HEAD、工作区状态、是否处于合并中、`test` 分支状态。
- `start-merge-to-test.sh`：记录原分支状态，切到 `test`，执行 `git pull origin test`，合并原分支；失败时自动回原分支并清理状态。
- `finalize-merge-to-test.sh`：确认冲突已解决，必要时完成 merge commit，推送 `test`，切回原分支并校验 SHA，同时清理状态。
- `abort-merge-to-test.sh`：放弃合并，执行 `git merge --abort`，切回原分支并校验 SHA，同时清理状态。

## 冲突处理准则

- 保留 `test` 上已有测试环境代码，不盲目覆盖。
- 保留原分支的新功能或修复逻辑。
- 两边新增内容互不冲突时应融合保留。
- 逻辑互斥时优先保证原分支业务意图，同时保持代码语法完整。

## 安全规则

- 不运行 `git reset --hard`、`git clean`、`git stash`，除非用户明确要求。
- `git pull origin test` 或非冲突类 merge 失败时，脚本会尽力 abort 当前 merge、切回原分支并清理状态。
- push 失败时仍切回原分支，并报告 `test` 本地已合并但未推送。
- 原分支 SHA 校验失败时必须明确告警。
