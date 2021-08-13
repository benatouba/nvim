local util = require "lspconfig/util"

local configs = require "lspconfig/configs"
configs["salt"] = {
    default_config = {
        cmd = { "python3", "-m", "salt_lsp" },
        on_attach = common_on_attach,
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


require'lspconfig'.salt.setup {
    -- cmd = {"/home/ben/.local/src/salt-lsp/.venv/bin/python3", "-m", "salt_lsp"},
    -- on_attach = common_on_attach,
}
