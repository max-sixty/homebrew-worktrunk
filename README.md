# Homebrew Tap for Worktrunk

> [!IMPORTANT]
> **Worktrunk is now in homebrew-core!** You can install directly with:
>
> ```sh
> brew install worktrunk
> ```
>
> If you previously installed from this tap, migrate with:
>
> ```sh
> brew uninstall wt
> brew untap max-sixty/worktrunk
> brew install worktrunk
> ```

---

Homebrew formulae for [Worktrunk](https://github.com/max-sixty/worktrunk) (`wt`), a Git worktree manager for trunk-based development.

## Installation (Legacy)

```sh
brew tap max-sixty/worktrunk
brew install wt
```

Or in a single command:

```sh
brew install max-sixty/worktrunk/wt
```

## Post-Installation Setup

Enable shell integration for directory switching and completions:

```sh
wt config shell install
```

## Updating

```sh
brew upgrade wt
```

## What is Worktrunk?

Worktrunk (`wt`) manages Git worktrees with a focus on trunk-based development workflows. It simplifies creating, switching between, and cleaning up worktrees while providing rich shell integration.

See the [main repository](https://github.com/max-sixty/worktrunk) for full documentation.
