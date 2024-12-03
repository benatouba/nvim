local M = {}

local wk_ok, wk = pcall(require, "which-key")
if not wk_ok then
  vim.notify("Which-key not found in overseer", vim.log.levels.ERROR)
end

M.config = function ()
  local status_ok, overseer = pcall(require, "overseer")
  if not status_ok then
    vim.notify("Overseer.nvim not okay")
    return
  end
  overseer.setup({
    actions = {
      ["Run script"] = {
        condition = function (task)
          if task.name == "run_script" then
            return true
          else
            return false
          end
        end,
        run = function (task)
          task:start()
        end,
      },
      ["Run python module"] = {
        condition = function (task)
          if task.name == "run_python_module" then
            return true
          else
            return false
          end
        end,
        run = function (task)
          task:start()
        end,
      },
    },
    task_list = {
      bindings = {
        ["r"] = "<cmd>OverseerQuickAction Run script<cr>",
      }
    }
  })
  wk.add({
    { "<leader>r", group = "+Run" },
    { "<leader>rt", "<cmd>OverseerToggle<cr>", desc = "Toggle" },
    { "<leader>rr", "<cmd>OverseerRun<cr>", desc = "Run" },
    { "<leader>rq", "<cmd>OverseerQuickAction<cr>", desc = "Quick Action" },
    { "<leader>ri", "<cmd>OverseerInfo<cr>", desc = "Info" },
    { "<leader>rb", "<cmd>OverseerBuild<cr>", desc = "Build" },
    { "<leader>rc", "<cmd>OverseerClose<cr>", desc = "Close" },
    { "<leader>rC", "<cmd>OverseerClearCache<cr>", desc = "Clear Cache" },
    { "<leader>rw", "<cmd>WatchRun<cr>", desc = "Watch Run" },
  })
  vim.api.nvim_create_user_command("WatchRun", function ()
    overseer.run_template({ name = "run script" }, function (task)
      if task then
        task:add_component({ "restart_on_save", paths = { vim.fn.expand("%:p") } })
        local main_win = vim.api.nvim_get_current_win()
        overseer.run_action(task, "open vsplit")
        vim.api.nvim_set_current_win(main_win)
      else
        vim.notify("WatchRun not supported for filetype " .. vim.bo.filetype, vim.log.levels.ERROR)
      end
    end)
  end, {})
  overseer.load_template("user.run_script")
  overseer.load_template("user.run_python_module")
end

return M
