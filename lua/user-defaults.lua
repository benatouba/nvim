O = {
    language_parsing = true,
    lsp = false,
    git = false,
    snippets = false,
    format = false,
    test = false,
    dap = false,
    misc = false,

    auto_close_tree = 0,
    auto_complete = true,
    colorscheme = 'lunar',
    hidden_files = true,
    wrap_lines = false,
    number = true,
    relative_number = true,
    shell = 'bash',
    mapleader = " ",
    galaxyline = {
        colors = {
            alt_bg = "#2E2E2E",
            grey = "#858585",
            blue = "#569CD6",
            green = "#608B4E",
            yellow = "#DCDCAA",
            orange = "#FF8800",
            purple = "#C586C0",
            magenta = "#D16D9E",
            cyan = "#4EC9B0",
            red = "#D16969",
            error_red = "#F44747",
            warning_orange = "#FF8800",
            info_yellow = "#FFCC66",
            hint_blue = "#9CDCFE"
        }
    },

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

    -- database = {save_location = '~/.config/nvcode_db', auto_execute = 1},
    python = {
        linter = '',
        -- @usage can be 'yapf', 'black'
        format = {
            auto = false,
            exe = '',
            args = {},
            stdin = false,
            cwd = vim.fn.getcwd(),
            isort = false
        },
        analysis = {
            type_checking = "basic",
            auto_search_paths = true,
            use_library_code_types = true
        }
    },
    -- dart = {sdk_path = '/usr/lib/dart/bin/snapshots/analysis_server.dart.snapshot'},
    lua = {
        format = {
            -- @usage can be 'lua-format'
            exe = '',
            -- @usage table, additional arguments to pass to formatter (not stdin arg)
            args = {},
            -- @usage boolean, pass file as stdin?
            stdin = false,
            -- @usage string, path from where to start looking for formatters config files
            cwd = false,
            -- @usage boolean, autoformat on save?
            auto = false
        }
    },
    sh = {
        -- @usage can be 'shellcheck'
        linter = '',
        format = {
            -- @usage can be 'shfmt'
            exe = '',
            -- @usage table, additional arguments to pass to formatter (not stdin arg)
            args = {},
            -- @usage boolean, pass file as stdin?
            stdin = false,
            -- @usage string, path from where to start looking for formatters config files
            cwd = false,
            -- @usage boolean, autoformat on save?
            auto = false
        },
        diagnostics = {virtual_text = true, signs = true, underline = true}
    },
    jsts = {
        -- @usage can be 'eslint'
        linter = '',
        format = {
            -- @usage can be 'prettier'
            exe = '',
            -- @usage table, additional arguments to pass to formatter (not stdin arg)
            args = {},
            -- @usage boolean, pass file as stdin?
            stdin = false,
            -- @usage string, path from where to start looking for formatters config files
            cwd = false,
            -- @usage boolean, autoformat on save?
            auto = false
        },
        diagnostics = {virtual_text = true, signs = true, underline = true}
    },
    json = {
        format = {
            -- @usage can be 'prettier'
            exe = '',
            -- @usage table, additional arguments to pass to formatter (not stdin arg)
            args = {},
            -- @usage boolean, pass file as stdin?
            stdin = false,
            -- @usage string, path from where to start looking for formatters config files
            cwd = false,
            -- @usage boolean, autoformat on save?
            auto = false
        },
        diagnostics = {virtual_text = true, signs = true, underline = true}
    },
    ruby = {
        format = {
            -- @usage string, your preferred ruby formatter
            exe = '',
            -- @usage table, additional arguments to pass to formatter (not stdin arg)
            args = {},
            -- @usage boolean, pass file as stdin?
            stdin = false,
            -- @usage string, path from where to start looking for formatters config files
            cwd = false,
            -- @usage boolean, autoformat on save?
            auto = false
        },
        diagnostics = {virtual_text = true, signs = true, underline = true}
    },
    rust = {
        format = {
            -- @usage can be 'rustfmt'
            exe = '',
            -- @usage table, additional arguments to pass to formatter (not stdin arg)
            args = {},
            -- @usage boolean, pass file as stdin?
            stdin = false,
            -- @usage string, path from where to start looking for formatters config files
            cwd = false,
            -- @usage boolean, autoformat on save?
            auto = false
        },
        diagnostics = {virtual_text = true, signs = true, underline = true}
    },
    -- tailwindls = {filetypes = {'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact'}},
    clang = {
        diagnostics = {virtual_text = true, signs = true, underline = true}
    },
    org = {agenda_files = {}, default_notes_file = ''},
    formatters = {}
}
-- css = {exe = '', autoformat = false, virtual_text = true},
-- json = {exe = '', autoformat = false, virtual_text = true}

DATA_PATH = vim.fn.stdpath('data')
CACHE_PATH = vim.fn.stdpath('cache')

P = function(v)
    print(vim.inspect(v))
    return v
end

if pcall(require, "plenary") then
    RELOAD = require("plenary.reload").reload_module

    R = function(name)
        RELOAD(name)
        return require(name)
    end
end
