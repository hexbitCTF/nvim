# nvim

My Neovim configuration managed with [lazy.nvim](https://github.com/folke/lazy.nvim).

## Structure

```
~/.config/nvim/
├── init.lua              # Entry point
├── lua/
│   ├── config/
│   │   ├── options.lua   # Editor options & :W command
│   │   ├── keybinds.lua  # Key mappings (leader = space)
│   │   └── lazy.lua      # Plugin manager bootstrap
│   └── plugins/
│       ├── colors.lua    # Tokyonight theme + lualine
│       ├── lsp.lua       # Mason + lspconfig + nvim-cmp + snippets
│       ├── telescope.lua # Fuzzy finder (files, grep, undo)
│       ├── treesitter.lua# Syntax highlighting & indentation
│       ├── nvim-tree.lua # File explorer (transparent)
│       ├── harpoon.lua   # Quick file navigation
│       ├── snacks.lua    # Dashboard with startup shortcuts
│       └── oneliners.lua # Fugitive (git) + color highlighter
```

## Features

- **Theme:** Follows the Hexarchy system theme via aether.nvim
- **LSP:** Lua, Python, C/C++, Bash, HTML, CSS via Mason
- **Completion:** nvim-cmp with luasnip + friendly-snippets
- **Navigation:** Telescope (files, grep, undo history), Harpoon
- **Tree-sitter:** Syntax highlighting + auto-indent for Lua, C, TSX, CSS, TS, Python, PHP
- **Status line:** lualine with auto theme
- **Dashboard:** Snacks.nvim startup screen with action shortcuts
- **Git:** vim-fugitive
- **File explorer:** nvim-tree (transparent, left sidebar)

## Key Bindings

| Key | Action |
| :--- | :--- |
| `<Space>` | Leader key |
| `<Space> e` | Toggle file explorer |
| `<Space> cd` | Open netrw |
| `<Space> ff` | Find files (hidden included) |
| `<Space> fg` | Live grep (hidden included) |
| `<Space> u` | Telescope undo history |
| `<Space> a` | Harpoon add file |
| `<Space> h` | Harpoon menu |
| `<Space> ls` | Start live-server on port 5500 |
| `<C-h/j/k/l>` | Harpoon nav file 1-4 |
| `K` | Hover documentation |
| `gd` | Go to definition |
| `<Space> rn` | Rename symbol |
| `<Space> ca` | Code action |
| `:W` | Write file with doas/sudo |

## Requirements

- Neovim >= 0.10
- `doas` or `sudo` (for `:W` command)
- LSP servers: lua-language-server, pyright, clangd, bash-language-server, ruff, vscode-html/css-language-server
