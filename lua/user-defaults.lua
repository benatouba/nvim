O = {
    language_parsing = true,
    lsp = false,
    git = false,
    snippets = false,
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
        hint_blue = "#9CDCFE",
      },
    },

    -- @usage pass a table with your desired languages
    treesitter = {
        ensure_installed = "all",
        ignore_install = {"haskell"},
        highlight = {enabled = true},
        playground = {enabled = true},
        rainbow = {enabled = true}
    },

    -- database = {save_location = '~/.config/nvcode_db', auto_execute = 1},
    python = {
        linter = 'flake8',
        -- @usage can be 'yapf', 'black'
        formatter = 'black',
        autoformat = true,
        isort = true,
        diagnostics = {virtual_text = {spacing = 0, prefix = ""}, signs = true, underline = true},
		analysis = {type_checking = "basic", auto_search_paths = true, use_library_code_types = true}
    },
    -- dart = {sdk_path = '/usr/lib/dart/bin/snapshots/analysis_server.dart.snapshot'},
    lua = {
        -- @usage can be 'lua-format'
        formatter = '',
        autoformat = false,
        diagnostics = {virtual_text = true, signs = true, underline = true}
    },
    sh = {
        -- @usage can be 'shellcheck'
        linter = '',
        -- @usage can be 'shfmt'
        formatter = '',
        autoformat = false,
        diagnostics = {virtual_text = true, signs = true, underline = true}
    },
    tsserver = {
        -- @usage can be 'eslint'
        linter = '',
        -- @usage can be 'prettier'
        formatter = '',
        autoformat = false,
        diagnostics = {virtual_text = true, signs = true, underline = true}
    },
    json = {
        -- @usage can be 'prettier'
        formatter = '',
        autoformat = false,
        diagnostics = {virtual_text = true, signs = true, underline = true}
    },
    -- tailwindls = {filetypes = {'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact'}},
    clang = {diagnostics = {virtual_text = true, signs = true, underline = true}},
	ruby = {
		diagnostics = {virtualtext = true, signs = true, underline = true},
		filetypes = {'rb', 'erb', 'rakefile'}
	}
    -- css = {formatter = '', autoformat = false, virtual_text = true},
    -- json = {formatter = '', autoformat = false, virtual_text = true}
}

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
