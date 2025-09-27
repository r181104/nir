# 🚀 A Modern Neovim Configuration 🚀

This Neovim configuration is designed for a modern and efficient workflow. It's built around `lazy.nvim` for plugin management and includes a curated set of plugins for everything from coding and debugging to git integration and fuzzy finding.

## 📜 Philosophy

The goal of this configuration is to create a development environment that is:

*   **⚡ Fast and Responsive**: Using `lazy.nvim` for plugin management ensures that Neovim starts quickly and runs smoothly.
*   **🎨 Visually Appealing and Informative**: The `tokyonight` colorscheme, `lualine` statusline, and `indent-blankline` provide a pleasant and informative UI.
*   **🧠 Powerful and Intelligent**: `nvim-treesitter` for advanced syntax highlighting and `blink.cmp` for autocompletion make coding faster and more efficient.
*   **🧩 Integrated and Seamless**: Tools like `fzf-lua` for fuzzy finding, `gitsigns` and `lazygit` for git integration, and `nvim-dap` for debugging are tightly integrated into the editor.
*   **🤖 Automated and Consistent**: `conform.nvim` automatically formats code on save, ensuring a consistent style across projects.

## ✨ Features

*   **📦 Plugin Management**: Uses `lazy.nvim` to manage plugins, with automatic updates on startup.
*   **💅 Aesthetics**: `tokyonight` colorscheme, `lualine` statusline, and `indent-blankline` for a modern look and feel.
*   **💡 Completion**: `blink.cmp` provides autocompletion, powered by `LuaSnip` for snippets.
*   **📁 File Navigation**: `oil.nvim` provides a simple and efficient file browser.
*   **🔍 Fuzzy Finding**: `fzf-lua` for finding files, buffers, and searching for text.
*   **🌿 Git Integration**: `gitsigns` for git decorations in the sign column and `lazygit` for a full-featured git UI.
*   **🌐 LSP**: `nvim-lspconfig` for language-specific features like go-to-definition, find-references, and diagnostics.
*   **📝 Formatting**: `conform.nvim` for automatic code formatting.
*   **🐞 Debugging**: `nvim-dap` for a full debugging experience within Neovim.
*   **↔️ Tmux Integration**: `vim-tmux-navigator` for seamless navigation between Neovim and tmux panes.
*   **🌐 Web Development**: Includes `LiveServer` and `PyServer` commands for quick web server setup.

## 💾 Installation

This configuration is intended for Arch Linux.

1.  **Install dependencies**:
    The `install` script will automatically install the necessary dependencies using `pacman`.

2.  **Run the installation script**:
    ```bash
    curl -fsSL https://raw.githubusercontent.com/r181104/neovim/refs/heads/master/install | sh
    ```

## ⌨️ Key Mappings

The leader key is set to `<Space>`.

### ⚙️ General

| Key         | Description                  |
| ----------- | ---------------------------- |
| `<leader>w` | 💾 Save file                    |
| `<leader>q` | 🚪 Quit                         |
| `<leader>e` | 📁 Open file explorer (Oil)     |
| `<leader>y` | 📋 Yank to system clipboard     |
| `<leader>so`| 🔄 Source current file          |
| `<leader>si`| 🔄 Source init.lua              |
| `<leader>ter`| 💻 Open terminal in vertical split |
| `<leader>tc` | 🎨 Toggle Colorizer             |

### 🔍 Fuzzy Finding (fzf-lua)

| Key         | Description        |
| ----------- | ------------------ |
| `<leader>ff`| 📄 Find files         |
| `<leader>fg`| 📝 Live grep          |
| `<leader>fb`| 📚 Find buffers       |
| `<leader>fh`| ❓ Search help tags   |

### 🌿 Git

| Key         | Description        |
| ----------- | ------------------ |
| `<leader>git`| 🐙 Open LazyGit       |
| `<leader>gb`| 👤 Git blame          |

### 🐞 Debugger (nvim-dap)

| Key         | Description                     |
| ----------- | ------------------------------- |
| `<leader>dc`| ▶️ Start/Continue debugging        |
| `<leader>dsi`| 🔽 Step into                       |
| `<leader>dso`| 🔼 Step out                        |
| `<leader>dsO`| ⏭️ Step over                       |
| `<leader>db`| 🔴 Toggle breakpoint               |
| `<leader>Db`| ❓ Set conditional breakpoint      |
| `<leader>Du`| 🖥️ Toggle DAP UI                   |
| `<leader>Dl`| 🔄 Run last debug configuration    |

### 🌐 LSP

| Key         | Description               |
| ----------- | ------------------------- |
| `gd`        | 🔎 Go to definition          |
| `gr`        | 📚 Find references           |
| `gi`        | 💡 Go to implementation      |
| `K`         | 📖 Hover documentation       |
| `<leader>ca`| 💡 Code action               |
| `<leader>rn`| ✏️ Rename symbol             |
| `<leader>for`| 💅 Format buffer             |

### ⚠️ Trouble

| Key | Description |
| --- | --- |
| `<leader>tt` | 🚨 Toggle Trouble |
| `[d` | 🔽 Next diagnostic |
| `]d` | 🔼 Previous diagnostic |

## 🤖 Autocommands

The `auto.lua` file contains several useful autocommands:

*   **🔄 Automatic Plugin Updates**: `lazy.nvim` checks for updates on startup.
*   **✨ Yank Highlighting**: Highlights the text that was just yanked.
*   **⌨️ LSP Keymaps**: Automatically sets up keymaps for LSP features when an LSP server attaches to a buffer.
*   **🎨 Custom Diagnostic Configuration**: Configures how diagnostics are displayed, including signs, virtual text, and floating windows.
*   **🌐 Live Server Commands**:
    *   `:LiveServer`: Starts a live server for the current directory.
    *   `:LiveServerStop`: Stops the live server.
    *   `:PyServer`: Starts a Python HTTP server for the current directory.
    *   `:PyServerStop`: Stops the Python HTTP server.

## 📂 Configuration Structure

*   `init.lua`: The main entry point.
*   `lua/`: Contains all the Lua configuration files.
    *   `opts.lua`: Basic Neovim options.
    *   `maps.lua`: Global key mappings.
    *   `auto.lua`: Autocommands.
    *   `plugins/`: Plugin configurations.

This structure makes it easy to find and customize different parts of the configuration.