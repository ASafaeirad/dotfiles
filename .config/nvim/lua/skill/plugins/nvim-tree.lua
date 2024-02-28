local M = {}

local function config()
    local status_ok, nvim_tree = pcall(require, "nvim-tree")
    if not status_ok then
        return
    end

    nvim_tree.setup({
        hijack_netrw = true,
        update_focused_file = {
            enable = true,
            update_cwd = true
        },
        filters = {
            dotfiles = false,
            custom = {"^\\.git"}
        },
        git = {
            enable = true,
            ignore = true,
            show_on_dirs = false
        },
        renderer = {
            root_folder_modifier = ":t",
            icons = {
                glyphs = {
                    default = "", -- 
                    symlink = "",
                    folder = {
                        arrow_open = "-", -- 
                        arrow_closed = "+", -- 
                        default = "", -- 
                        open = "", -- 
                        empty = "", -- 
                        empty_open = "", -- 
                        symlink = "",
                        symlink_open = ""
                    },
                    git = {
                        unstaged = "",
                        staged = "S",
                        unmerged = "",
                        renamed = "➜",
                        untracked = "",
                        deleted = "",
                        ignored = "◌"
                    }
                }
            }
        },
        diagnostics = {
            enable = true,
            show_on_dirs = false,
            icons = {
                -- hint = "",
                -- info = "",
                -- warning = "",
                -- error = "",
            }
        },
        view = {
            width = 30,
            side = "left"
        }
    })
end

M.config = config

return M
