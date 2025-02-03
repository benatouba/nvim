local M = {}
local org_ok, org = pcall(require, "orgmode")
if not org_ok then
  vim.notify("orgmode not okay")
  return
end

local ts_ok, tsc = pcall(require, "nvim-treesitter.configs")
if not ts_ok then
  vim.notify("treesitter not okay in orgmode.nvim")
  return
end

tsc.setup({
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { "org" }, -- Required since TS highlighter doesn't support all syntax features (conceal)
  },
  ensure_installed = { "org" },                    -- Or run :TSUpdate org
})
M.config = function ()
  org.setup({
    ui = {
      menu = {
        handler = function (data)
          -- your handler here, for example:
          local options = {}
          local options_by_label = {}

          for _, item in ipairs(data.items) do
            -- Only MenuOption has `key`
            -- Also we don't need `Quit` option because we can close the menu with ESC
            if item.key and item.label:lower() ~= "quit" then
              table.insert(options, item.label)
              options_by_label[item.label] = item
            end
          end

          local handler = function (choice)
            if not choice then
              return
            end

            local option = options_by_label[choice]
            if option.action then
              option.action()
            end
          end

          vim.ui.select(options, {
            propmt = data.propmt,
          }, handler)
        end,
      },
    },
    org_agenda_files = { "~/documents/vivere/org/**/*", },
    org_default_notes_file = "~/documents/vivere/org/refile.org",
    notifications = {
      enabled = true,
      deadline_warning_reminder_time = true,
      reminder_time = { 0, 10, 30, 60 }
    },
    org_agenda_min_height = 22,
    org_agenda_text_search_extra_files = { "agenda-archives" },
    org_capture_templates = {
      t = {
        description = "Task",
        template = "* TODO %?\n  %U\n  %a",
        target = "~/documents/vivere/org/todo.org"
      },
      n = {
        description = "Note",
        template = "* %?\n  %U\n  %a",
        target = "~/documents/vivere/org/refile.org"
      },
      j = {
        description = "Journal",
        template = "\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?",
        target = "~/documents/vivere/org/journal.org"
      },
      e = "Event",
      er = {
        description = "Reccuring Event",
        headline = "Recurring",
        template = "* %?\n %T :EVENT:\n SCHEDULED: %^T\n  %a",
        -- template = "* MEETING %? :MEETING:\n  %U",
        target = "~/documents/vivere/org/events.org"
      },
      eo = {
        description = "one-time Event",
        headline = "One-Time",
        template = "* %?\n %T :EVENT:\n SCHEDULED: %^T\n  %a",
        target = "~/documents/vivere/org/events.org",
      },
      m = "Meeting",
      mr = {
        description = "Reccuring Meeting",
        headline = "Recurring",
        template = "* %? :MEETING:\n SCHEDULED: %^T",
        target = "~/documents/vivere/org/meetings.org"
      },
      mo = {
        description = "one-time Meeting",
        headline = "One-Time",
        template = "* %? :MEETING:\n SCHEDULED: %^T",
        target = "~/documents/vivere/org/meetings.org",
      }
    }
  })

  local isOk, which_key = pcall(require, "which-key")
  if not isOk then
    vim.notify("which-key not okay in orgmode", vim.log.levels.ERROR)
    return
  end

  local maps = {
    { "<leader>o", group = "Org", nowait = false, remap = false, icon = { icon = "", color = "purple" } },
    { "<leader>oa", "<cmd>lua require('orgmode').action('agenda.prompt')<CR>", desc = "org-Agenda", nowait = true, remap = false },
    { "<leader>oc", "<cmd>lua require('orgmode').action('capture.prompt')<CR>", desc = "org-Capture", nowait = true, remap = false },
  }

  which_key.add(maps)
end

return M
