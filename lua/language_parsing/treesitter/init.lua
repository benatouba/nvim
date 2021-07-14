-- local M = {}
-- M.config = function()
    require'nvim-treesitter.configs'.setup {
        ensure_installed = O.treesitter.ensure_installed,
        ignore_install = O.treesitter.ignore_install,
        highlight = {
            enable = O.treesitter.highlight.enabled, -- false will disable the whole extension
            config = {
                vue = {
                    style_element = '// %s'
                }
            }
        },
        context_commentstring = { enable = true },
        indent = {
            enable = true,
            disable = { 'python', 'html' }
        },
        playground = {
            enable = O.treesitter.playground.enabled,
            disable = {},
            updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
            persist_queries = false -- Whether the query persists across vim sessions
        },
        autotag = {enable = true},
        rainbow = {
						enable = O.treesitter.rainbow.enabled,
						extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
						max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
				},

        textobjects = {
            select = {
                enable = true,
                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = true,
                keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                },
            },

            swap = {
                enable = true,
                swap_next = {
                    ["gj"] = "@parameter.inner",
                },
                swap_previous = {
                    ["gk"] = "@parameter.inner",
                },
            },

            move = {
                enable = true,
                set_jumps = true, -- adds movement to the jumplist
                goto_next_start = {
                  ["]m"] = "@function.outer",
                  ["]]"] = "@class.outer",
                },
                goto_next_end = {
                  ["]M"] = "@function.outer",
                  ["]["] = "@class.outer",
                },
                goto_previous_start = {
                  ["[m"] = "@function.outer",
                  ["[["] = "@class.outer",
                },
                goto_previous_end = {
                  ["[M"] = "@function.outer",
                  ["[]"] = "@class.outer",
                },
            },

            lsp_interop = {
                enable = vim.fn.has('nvim-lspconfig') or false,
                peek_definition_code = {
                  ["df"] = "@function.outer",
                  ["dF"] = "@class.outer",
                },
            },
        },

        refactor = {
            highlight_definitions = {enable = true},
            highlight_current_scope = { enable = true },
            smart_rename = {
              enable = true,
              keymaps = {
                smart_rename = "grr",
              },
            },
        }
    }
-- end
-- return M
