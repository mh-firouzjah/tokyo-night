# Tokyo Night Zim Prompt

A compact, single-line Zsh prompt theme for Zim, inspired by the [Tokyo Night color theme](https://github.com/folke/tokyonight.nvim) and using colors from its palette. Tokyo Night was originally ported from the [TokyoNight VS Code theme](https://github.com/enkia/tokyo-night-vscode-theme). This project is an independent Zim prompt theme; it is not affiliated with or endorsed by those projects.

The prompt shows the Fedora mark by default, shortened current path, Git branch and status, active Python environment (when set), command duration (at least three seconds), nonzero exit code (when present), and prompt marker. Root gets `⮞#`; regular users get `⮞`. Set `TOKYO_NIGHT_DISTRO_SYMBOL` to change the distro glyph. The theme has no right prompt or background color.

It uses Zim's `git-info`, `prompt-pwd`, and `duration-info` modules. Git markers are `` branch, `+` staged, `!` unstaged, `?` untracked, `~` conflicted, `⇡`/`⇣` ahead/behind, `*` stashed, and `@` detached commit. Duration uses ``; Python uses ``. Nerd Font glyphs require a Nerd Font.

Verbose Git status is enabled by default and shows file counts. Set `TOKYO_NIGHT_GIT_VERBOSE=0` for non-verbose mode; staged and unstaged markers remain without counts, while untracked-file markers are unavailable in that mode.

The default Tokyo Night palette is embedded in `tokyo-night.zsh-theme`. An optional Nord palette is provided in `palettes/nord.zsh`. To use it, set `TOKYO_NIGHT_PALETTE_FILE="$HOME/.config/zsh/themes/tokyo-night/palettes/nord.zsh"` in your Zsh config. Set `TOKYO_NIGHT_DISTRO_SYMBOL` there to replace the default Fedora glyph ``. Colors are foreground-only.

## Install

Load `git-info`, `prompt-pwd`, and `duration-info` before the theme. For a local install, copy this directory to `~/.config/zsh/themes/tokyo-night/`, then add this after those modules in `~/.zimrc`:

    zmodule ${HOME}/.config/zsh/themes/tokyo-night

To publish as a Zim-loadable GitHub module, use this directory as the repository root and name the repository `tokyo-night`. Then add `zmodule mh-firouzjah/tokyo-night` after the prompt-data modules. Zim's default module loader looks for a theme file matching the module name, so keep the filename `tokyo-night.zsh-theme` and include the `palettes/` directory. If you choose another repository name, set the module name explicitly with Zim's `--name tokyo-night` option.

## Attribution

The prompt implementation and documentation were created with extensive assistance from OpenAI Codex, under the user's direction and review. Tokyo Night palette inspiration and color values are attributed to the upstream projects linked above. The included MIT license applies to this prompt theme's original code and documentation, not to the upstream Tokyo Night projects or Nerd Font glyph designs.
