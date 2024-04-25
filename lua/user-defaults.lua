O = {
    language_parsing = true,
    lsp = false,
    git = false,
    snippets = false,
    test = false,
    dap = false,
    misc = false,

    auto_close_tree = 0,
    auto_complete = true,
    hidden_files = true,
    wrap_lines = false,
    number = true,
    relative_number = true,
    shell = '/usr/bin/zsh',
    mapleader = " ",

    -- @usage pass a table with your desired languages
    treesitter = {
        ensure_installed = "all",
        ignore_install = {"haskell"},
        highlight = {enabled = true},
        playground = {enabled = true},
        rainbow = {enabled = true}
    },
    diagnostics = {
        virtual_text = {active = true, spacing = 0, prefix = ""},
        signs = true,
        underline = true
    },

    org = {agenda_files = {}, default_notes_file = ''},
}

DATA_PATH = vim.fn.stdpath('data')
CACHE_PATH = vim.fn.stdpath('cache')

P = function(v)
    local logger = require("structlog").get_logger("INFO:")
    return logger:info(v)
end

if pcall(require, "plenary") then
    RELOAD = require("plenary.reload").reload_module

    R = function(name)
        RELOAD(name)
        return require(name)
    end
end
