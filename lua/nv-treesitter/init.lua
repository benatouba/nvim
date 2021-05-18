require'nvim-treesitter.configs'.setup {
    -- ensure_installed = {'python', 'javascript', 'vue', 'lua'},
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
    rainbow = {enable = O.treesitter.rainbow.enabled},
    -- refactor = {highlight_definitions = {enable = true}}
}
