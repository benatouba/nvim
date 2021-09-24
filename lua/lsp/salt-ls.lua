local util = require "lspconfig/util"
local configs = require "lspconfig/configs"
local servers = require "nvim-lsp-installer.servers"
local server_module = require "nvim-lsp-installer.server"
local path = require "nvim-lsp-installer.path"
local installers = require "nvim-lsp-installer.installers"
local shell = require "nvim-lsp-installer.installers.shell"
-- local pip3 = require "nvim-lsp-installer.installers.pip3"
local std = require "nvim-lsp-installer.installers.std"
local process = require "nvim-lsp-installer.process"
local platform = require "nvim-lsp-installer.platform"
local server_name = "salt"
local root_dir = server_module.get_server_root_path(server_name)

configs[server_name] = {
    default_config = {
        cmd = {
            root_dir .. "venv/bin/python3", "-m", "salt_lsp"
        },
        filetypes = {"sls"},
        root_dir = util.root_pattern("top.sls", ".git", vim.fn.getcwd())
    },
    docs = {
        package_json = "https://github.com/dcermak/salt-lsp/tree/main",
        description = [[
            `salt-lsp` can be installed via `poetry` and `pip`:
            ```sh
            poetry install
            poetry run dump_state_name_completions
            poetry build

            pip install --user --force-reinstall dist/salt_lsp-0.0.1*whl
            ```
        ]],
        default_config = {
            root_dir = [[root_pattern("top.sls", ".git", vim.fn.getcwd())]]
        }
    }
}

local installer_chain = {
    -- std.git_clone("https://github.com/dcermak/salt-lsp.git"),
    shell.polyshell("cd " .. root_dir .. " && git clone https://github.com/dcermak/salt-lsp.git ."),
    shell.polyshell("cd " .. root_dir .. " && poetry install && poetry run dump_state_name_completions && poetry build"),
    shell.polyshell("cd " .. root_dir .. " && python3.9 -m venv venv" ),
    shell.polyshell("cd " .. root_dir .. " && ./venv/bin/pip3 install --force-reinstall dist/salt_lsp-0.0.1-py3-none-any.whl")
}

local salt = server_module.Server:new {
    name = server_name,
    root_dir = root_dir,
    installer = installer_chain,
    default_options = {
        cmd = { path.concat { root_dir, "venv", "bin", "python3" }, "-m", "salt_lsp" },
    },
}

servers.register(salt)
