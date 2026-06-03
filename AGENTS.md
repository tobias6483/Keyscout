# Agent Workflow For KeyScout

This file is for coding agents and maintainers with write access to the
`tobias6483/Keyscout` repository. KeyScout is open source, so external
contributors may use the normal fork-based GitHub pull request workflow instead.

## Branch Protection Facts

- `main` is protected.
- `enforce_admins` is enabled, so branch rules also apply to the owner/admin.
- Direct pushes to `main` should be rejected.
- Force pushes to `main` are disabled.
- Deleting `main` is disabled.
- Pull requests are required before merging to `main`.
- Approving review count is currently `0`, so another person's approval is not
  required before merge.
- GitHub rejects self-approval when the same account opened the PR. That is
  normal and is not a blocker while `required_approving_review_count` remains
  `0`.
- The required GitHub Actions check should be `Swift Build and Test` once the
  workflow has run successfully on `main`.

## Tooling Rule

Use local `git` for branch, stage, commit, and push operations.

Use the authenticated GitHub CLI (`gh`) as the primary tool for PR creation,
marking PRs ready, and merging in this repo.

## Required Flow

Do this:

```text
branch -> edit -> test -> stage -> commit -> push -> PR -> checks green -> merge -> delete branch
```

Do not do this:

```text
edit on main -> commit -> push main
```

## Step-By-Step

Start from an up-to-date `main` and create a branch:

```sh
git switch main
git pull --ff-only
git switch -c codex/short-description
```

Before staging, inspect status and diff:

```sh
git status -sb
git diff
```

Stage only files relevant to the current task:

```sh
git add <relevant-files>
```

Run the required local check:

```sh
swift test
```

If app bundle packaging changes, also run:

```sh
scripts/build_app.sh
```

Commit and push the branch:

```sh
git commit -m "Short description"
git push -u origin codex/short-description
```

Open a PR against `main`:

```sh
gh pr create --base main --head codex/short-description
```

When the PR is ready and checks are green:

```sh
gh pr merge <number> --squash --delete-branch
```

Clean up locally after merge:

```sh
git switch main
git pull --ff-only
git fetch --prune
```

## Notes For Agents

- Never stage unrelated user changes silently.
- Do not leave a PR branch hanging if the user expects the change to be shipped
  and checks are green.
- If checks are still running, report that the PR branch will remain visible
  until the PR is merged and the branch is deleted.
- Use PRs even for documentation-only changes.
- Keep `project.md` local-only. It is ignored by git and should not be published
  to GitHub.
