# Homebrew Tap for Worktrunk

Homebrew formulae for [Worktrunk](https://github.com/max-sixty/worktrunk) (`wt`), a Git worktree manager for trunk-based development.

## Installation

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
wt configure-shell
```

## Updating

```sh
brew upgrade wt
```

## What is Worktrunk?

Worktrunk (`wt`) manages Git worktrees with a focus on trunk-based development workflows. It simplifies creating, switching between, and cleaning up worktrees while providing rich shell integration.

See the [main repository](https://github.com/max-sixty/worktrunk) for full documentation.
