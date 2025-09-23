local isOk, neogit = pcall(require, "neogit")
if not isOk then
  vim.notify("Neogit not okay")
end

local wkOk, wk = pcall(require, "which-key")
if not wkOk then
  vim.notify("Which-key not okay in neogit")
end
local M = {}

M.config = function ()
  local dvOk, _ = pcall(require, "diffview")
  if not dvOk then
    vim.notify("Diffview not okay in neogit")
  end
  local tsOk, _ = pcall(require, "diffview")
  if not tsOk then
    vim.notify("Telescope not okay in neogit")
  end
  neogit.setup {
    integrations = {
      diffview = dvOk,
      telescope = tsOk,
    },
    disable_commit_confirmation = true,
    graph_style = "unicode",
    git_services = {
      ["gitlab.klima.tu-berlin.de"] = {
        pull_request = "https://gitlab.klima.tu-berlin.de/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
        commit = "https://gitlab.klima.tu-berlin.de/${owner}/${repository}/-/commit/${oid}",
        tree = "https://gitlab.klima.tu-berlin.de/${owner}/${repository}/-/tree/${branch_name}?ref_type=heads",
      },
    }
  }
  wk.add(
    {
      { "<leader>g", group = "+Git", nowait = false, remap = false },
      { "<leader>gb", "<cmd>Neogit branch<cr>", desc = "Branch (Menu)", nowait = false, remap = false },
      { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Commit (Menu)", nowait = false, remap = false },
      { "<leader>gC", "<cmd>Neogit cherry_pick<cr>", desc = "Cherry Pick (Menu)", nowait = false, remap = false },
      { "<leader>gD", "<cmd>Neogit diff<cr>", desc = "Diff (Menu)", nowait = false, remap = false },
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit (alias)", nowait = false, remap = false },
      { "<leader>gl", "<cmd>NeogitLogCurrent<cr>", desc = "Log", nowait = false, remap = false },
      { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit", nowait = false, remap = false },
      { "<leader>gp", "<cmd>Neogit pull<cr>", desc = "Pull", nowait = false, remap = false },
      { "<leader>gP", "<cmd>Neogit push<cr>", desc = "Push", nowait = false, remap = false },
    }
  )
end

return M
