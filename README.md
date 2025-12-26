# Dotfiles

Personal dotfiles for my macOS setup.

This repository contains configuration files for tools I use regularly, including my editor, shell, terminal, and various system utilities.

## Usage

The dotfiles are managed using **GNU Stow**.

From the repository root, configurations can be linked with:

```bash
stow <package>
```

Or, to create symlinks for all contents of the repository:

```bash
stow .
```

## Notes

These dotfiles are tailored to my system and workflow.
Machine-specific values and secrets are intentionally excluded.
Adapt or copy any contents as you like.
