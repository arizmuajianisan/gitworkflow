# gitworkflow

[![npm version](https://badge.fury.io/js/@arizmuajianisan%2Fgitworkflow.svg)](https://badge.fury.io/js/@arizmuajianisan%2Fgitworkflow)
[![npm downloads](https://img.shields.io/npm/dm/@arizmuajianisan%2Fgitworkflow.svg)](https://npmjs.org/package/@arizmuajianisan%2Fgitworkflow)
[![GitHub license](https://img.shields.io/github/license/arizmuajianisan/gitworkflow.svg)](https://github.com/arizmuajianisan/gitworkflow/blob/main/LICENSE)

> Created by [arizmuajianisan](https://github.com/arizmuajianisan)
>
> A one-command setup for a **professional Git workflow**  
> (semantic-release + commitlint + Husky + CHANGELOG) – zero config.
>
> This project is an update from my previous project [git-workflow-init](https://github.com/arizmuajianisan/git-workflow-init)

---

## 📚 Table of contents

- [gitworkflow](#gitworkflow)
  - [📚 Table of contents](#-table-of-contents)
  - [✨ What you get](#-what-you-get)
  - [📦 Installation](#-installation)
    - [Quick (no install)](#quick-no-install)
    - [Global install](#global-install)
  - [🚀 Usage](#-usage)
  - [🎯 Commit message format](#-commit-message-format)
  - [🔧 Configuration](#-configuration)
  - [🤖 CI / CD](#-ci--cd)
  - [📋 Requirements](#-requirements)
  - [🔍 Troubleshooting](#-troubleshooting)
  - [🤝 Contributing](#-contributing)
  - [📝 TODO](#-todo)
  - [📄 License](#-license)

## ✨ What you get

| Feature                     | Included                                |
| --------------------------- | --------------------------------------- |
| Conventional commit linting | `@commitlint/cli`                       |
| Automatic versioning        | `release-it` + `conventional-changelog` |
| CHANGELOG.md generation     | Auto-created                            |
| Git hooks                   | Husky                                   |
| GitHub releases             | Tagged release notes                    |
| Zero-config                 | Works out of the box                    |

---

## 📦 Installation

### Quick (no install)

```bash
npx @arizmuajianisan/gitworkflow
```

### Global install

```bash
npm i -g @arizmuajianisan/gitworkflow
npx @arizmuajianisan/gitworkflow --yes
```

---

## 🚀 Usage

1. **Inside any repo**:

   ```bash
   cd my-project
   npx @arizmuajianisan/gitworkflow
   ```

2. **Follow the prompts** (or `--yes` to skip).

3. **Start committing**:

   ```bash
   git add .
   git commit -m "feat: add dark-mode toggle"
   ```

4. **Release**:

   ```bash
   npm run release
   ```

   This will:
   - calculate the next **semver** (patch / minor / major) from commit messages
   - create a **CHANGELOG.md**
   - push a **tagged release** to GitHub

   Run `--dry-run` to see what will happen without actually releasing.

---

## 🎯 Commit message format

We follow [Conventional Commits](https://www.conventionalcommits.org).

| Type                                  | Release level |
| ------------------------------------- | ------------- |
| `feat`                                | minor         |
| `fix` / `perf` / `refactor`           | patch         |
| `feat!:` or footer `BREAKING CHANGE:` | major         |

Examples:

This will create a **patch** release, for example `v1.0.0` -> `v1.0.1`:

```text
fix: handle null values
```

This will create a **minor** release, for example `v1.0.0` -> `v1.1.0`:

```text
feat: add dark-mode toggle
```

This will create a **major** release, for example `v1.0.0` -> `v2.0.0`:

```text
feat!: drop Node 16 support
```

---

## 🔧 Configuration

Everything is pre-configured; advanced tweaks can be made in:

| File                   | Purpose             |
| ---------------------- | ------------------- |
| `.release-it.json`     | release-it settings |
| `commitlint.config.js` | commit lint rules   |
| `.husky/`              | Git hooks           |

---

## 🤖 CI / CD

No extra setup required; just set the secret:

```yaml
# GitHub Actions example
- name: Release
  run: npm run release
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

---

## 📋 Requirements

- Node.js ≥ 18
- Git repo (initialized or empty)
- GitHub personal access token (classic or fine-grained) with **repo** scope

---

## 🔍 Troubleshooting

**Hook not running?**

```bash
npm run prepare   # re-install Husky hooks
```

**Need to change token?**  
Edit `.env`:

```bash
GITHUB_TOKEN=ghp_xxxx
```

---

## 🤝 Contributing

1. Fork the repo
2. Clone the fork
   ```bash
   git clone https://github.com/arizmuajianisan/gitworkflow.git
   cd gitworkflow
   ```
3. Install dependencies
   ```bash
   npm install
   ```
4. Create your feature branch
   ```bash
   git checkout -b <your-feature-branch>
   ```
5. Commit your changes
   ```bash
   git add .
   git commit -m "feat: add dark-mode toggle"
   ```
6. Push to your fork
   ```bash
   git push origin <your-feature-branch>
   ```
7. Open a Pull Request

---

## 📝 TODO

- [ ] Compatibility with Husky v10

  > husky - DEPRECATED. Please remove the following two lines from .husky/pre-push:

  ```bash
  #!/usr/bin/env sh
  . "$(dirname -- "$0")/_/husky.sh"
  ```

  > They WILL FAIL in v10.0.0

- [ ] Add CLI selection for package manager (yarn, pnpm)
- [ ] Add CLI configuration for rules on commitlint
- [ ] Add capability to run `bats` tests on non-main branch

---

## 📄 License

[MIT](LICENSE)
