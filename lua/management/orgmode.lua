local M = {}
local org_ok, org = pcall(require, "orgmode")
if not org_ok then
  vim.notify("orgmode not okay")
  return
end
local menu_ok, Menu = pcall(require, "org-modern.menu")
if not menu_ok then
  vim.notify("org-modern.menu not okay")
end

M.config = function ()
  org.setup({
    ui = {
      menu = {
        handler = function (data)
          Menu:new({
            window = {
              margin = { 0, 0, 0, 0 },
              padding = { 0, 0, 0, 0 },
              border = false,
            },
          }):open(data)
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

end

return M
