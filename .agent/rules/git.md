# Rule: git is read-only for agents

Agents use git **only to read** data. All changes to git state — in root and in
every submodule — are made by the user.

## Allowed (read-only)
- Inspect state: `git status`, `git log`, `git show`, `git diff`, `git blame`, `git grep`, `git shortlog`, `git reflog`
- Compare with previous commits or other branches **without checking them out**:
  `git diff main..feature`, `git log other-branch`, `git show other-branch:path/to/file`
- List refs and config: `git branch` / `git tag` (listing only), `git remote -v`,
  `git config --get|--list`, `git submodule status`, `git stash list|show`, `git worktree list`
- Plumbing that only reads: `git ls-files`, `git ls-tree`, `git rev-parse`, `git cat-file`, `git merge-base`, …
- `gh` read commands only: `gh pr|issue|repo|run view|list|status|diff|checks`

## Forbidden (anything that writes)
- Index/working tree: `add`, `rm`, `mv`, `restore`, `reset`, `checkout`, `switch`, `clean`, `apply`, `stash` (push/pop/apply/drop)
- History/refs: `commit`, `merge`, `rebase`, `cherry-pick`, `revert`, `tag <name>`, `branch <name>`/`-d`/`-m`, `notes`
- Remotes: `push`, `pull`, `fetch`, `clone`, `submodule update|add|init|sync`, `remote add|remove|set-url`
- Config: `git config <key> <value>`, `git init`
- `gh` commands that change anything (create/merge/close/edit/comment/sync/…, `gh api` with a non-GET method)

When a task needs a git change, **stop and tell the user** the exact commands to run.
The only exception: the user explicitly asks, in the current session, for a specific
git write action — then do exactly that one action and nothing more.

## Optional enforcement
`.agent/hooks/git_read_only_check.sh "<command>"` exits `0` for read-only commands
and `1` (with the reason) for commands that write. Wire it into your tool's personal
(not committed) pre-command hook if the tool supports one.
