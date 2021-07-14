local folder = vim.fn.stdpath('data') .. "/lspinstall/salt/src/salt-lsp"
local python_path = folder .. "/.venv/bin/python3"
local lsp_path = folder .. "/salt_lsp/__main__.py"
local util = require "lspconfig/util"

local configs = require "lspconfig/configs"
configs["salt"] = {
    default_config = {
            cmd = {python_path .. " " .. lsp_path},
            -- cmd = {python_path .. " -m salt_lsp --tcp"},
            -- on_attach = common_on_attach,
            filetypes = {"sls", "salt", "saltfile"},
            root_dir = util.root_pattern(".git", "salt", vim.fn.getcwd())
        },
    docs = {
        package_json = "https://raw.githubusercontent.com/redhat-developer/vscode-yaml/master/package.json",
        description = [[
            https://github.com/redhat-developer/yaml-language-server
            `yaml-language-server` can be installed via `npm`:
            ```sh
            npm install -g yaml-language-server
            ```
        ]],
        default_config = {
            root_dir = [[root_pattern(".git", "salt", vim.fn.getcwd())]],
        },
    },
}

require'lspconfig'.salt.setup{}
