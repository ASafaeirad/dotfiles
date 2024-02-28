local M = {}

local function get_pickers(actions)
    return {
        find_files = {
            theme = "dropdown",
            hidden = true,
            previewer = false
        },
        frecency = {
            previewer = false,
            theme = "dropdown"
        },
        live_grep = {
            only_sort_text = true,
            theme = "dropdown"
        },
        grep_string = {
            only_sort_text = true,
            theme = "dropdown"
        },
        buffers = {
            theme = "dropdown",
            previewer = false,
            initial_mode = "normal",
            mappings = {
                i = {
                    ["<C-d>"] = actions.delete_buffer
                },
                n = {
                    ["dd"] = actions.delete_buffer
                }
            }
        },
        planets = {
            show_pluto = true,
            show_moon = true
        },
        git_files = {
            theme = "dropdown",
            hidden = true,
            previewer = false,
            show_untracked = true
        },
        lsp_references = {
            theme = "dropdown",
            initial_mode = "normal"
        },
        lsp_definitions = {
            theme = "dropdown",
            initial_mode = "normal"
        },
        lsp_declarations = {
            theme = "dropdown",
            initial_mode = "normal"
        },
        lsp_implementations = {
            theme = "dropdown",
            initial_mode = "normal"
        }
    }
end

local function config()
    local telescope_ok, telescope = pcall(require, "telescope")
    if not telescope_ok then
        return
    end

    local actions = require("telescope.actions")

    telescope.setup({
        defaults = {
            history = {
                path = "~/.local/share/nvim/databases/telescope_history.sqlite3",
                limit = 100
            },
            prompt_prefix = " ",
            selection_caret = "> ",
            entry_prefix = "  ",
            initial_mode = "insert",
            selection_strategy = "reset",
            sorting_strategy = "descending",
            layout_strategy = "horizontal",
            file_ignore_patterns = {".git", "node_modules", ".cache", "%.o", "%.a", "%.out", "%.class", "%.pdf",
                                    "%.mkv", "%.mp4", "%.zip"},
            mappings = {
                i = {
                    ["<C-u>"] = false,
                    ["<C-n>"] = actions.move_selection_next,
                    ["<C-p>"] = actions.move_selection_previous,
                    ["<C-c>"] = actions.close,
                    ["<C-j>"] = actions.cycle_history_next,
                    ["<C-k>"] = actions.cycle_history_prev,
                    ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                    ["<CR>"] = actions.select_default
                },
                n = {
                    ["<C-n>"] = actions.move_selection_next,
                    ["<C-p>"] = actions.move_selection_previous,
                    ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist
                }
            },
            layout_config = {
                width = 0.75,
                preview_cutoff = 120,
                horizontal = {
                    preview_width = function(_, cols, _)
                        if cols < 120 then
                            return math.floor(cols * 0.5)
                        end
                        return math.floor(cols * 0.6)
                    end,
                    mirror = false
                },
                vertical = {
                    mirror = false
                }
            },
            pickers = get_pickers(actions)
        },
        vimgrep_arguments = {"rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column",
                             "--smart-case", "--hidden", "--glob='!{**/node_modules/*,**/.git/*,**/package-lock.json}'"},
        pickers = get_pickers(actions),
        extensions = {
            frecency = {
                default_workspace = "CWD",
                show_filter_column = false,
                ignore_patterns = {"*.git/*", "*node_modules/*"},
                previewer = false
            },
            fzy_native = {
                fuzzy = true, -- false will only do exact matching
                override_generic_sorter = true, -- override the generic sorter
                override_file_sorter = true, -- override the file sorter
                case_mode = "smart_case" -- or "ignore_case" or "respect_case"
            },
            media_files = {
                filetypes = {"png", "webp", "jpg", "jpeg"},
                find_command = {"rg", "--files", "--hidden", "--glob", "!.git/*"}
            },
            ["ui-select"] = {require("telescope.themes").get_dropdown({})}
        }
    })

    telescope.load_extension("frecency")
    telescope.load_extension("fzy_native")
    telescope.load_extension("media_files")
    telescope.load_extension("ui-select")
    telescope.load_extension("smart_history")
end

M.config = config

return M
