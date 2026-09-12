-- Notes: obsidian vaults (markdown) and orgmode.
return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    cmd = "Obsidian",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    keys = {
      { "<leader>od", "<cmd>Obsidian dailies<CR>", desc = "Dailies" },
      { "<leader>on", "<cmd>Obsidian new<CR>", desc = "New note" },
      { "<leader>oN", "<cmd>Obsidian new_from_template<CR>", desc = "New note from Template" },
      { "<leader>ot", "<cmd>Obsidian today<CR>", desc = "Today note" },
      { "<leader>oT", "<cmd>Obsidian tomorrow<CR>", desc = "Tomorrow note" },
      { "<leader>os", "<cmd>Obsidian search<CR>", desc = "Search Workspace" },
      { "<leader>or", "<cmd>Obsidian rename<CR>", desc = "Rename" },
      { "<leader>ov", "<cmd>Obsidian workspace vivere<CR>", desc = "Vivere (Workspace)" },
      { "<leader>ow", "<cmd>Obsidian workspace work<CR>", desc = "Work (Workspace)" },
      { "<leader>oy", "<cmd>Obsidian yesterday<CR>", desc = "Yesterday note" },
      { "<localleader>ob", "<cmd>Obsidian backlinks<CR>", desc = "Backlinks" },
      { "<localleader>ol", "<cmd>Obsidian links<CR>", desc = "Links" },
      { "<localleader>oo", "<cmd>Obsidian open<CR>", desc = "Open in Obsidian" },
      { "<localleader>op", "<cmd>Obsidian paste_img<CR>", desc = "Paste image" },
      { "<localleader>or", "<cmd>Obsidian rename<CR>", desc = "Rename" },
      { "<localleader>os", "<cmd>Obsidian quick_switch<CR>", desc = "Quick switch" },
      { "<localleader>ot", "<cmd>Obsidian tags<CR>", desc = "Tags" },
      { "<localleader>oT", "<cmd>Obsidian template<CR>", desc = "Template" },
      { "<C-Space>", "<cmd>Obsidian toggle_checkbox<CR>", desc = "Toggle Checkbox" },
    },
    ---@module 'obsidian'
    ---@type obsidian.config.Internal
    opts = function()
      return {
        legacy_commands = false,
        notes_subdir = "notes",
        new_notes_location = "current_dir",
        workspaces = {
          {
            name = "vivere",
            path = "~/projects/vivere",
          },
          {
            name = "work",
            path = "~/projects/fg_doku",
          },
        },
        note_id_func = function(title)
          local date = os.date("%Y-%m-%d")
          local suffix = ""
          if title ~= nil then
            suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
          else
            for _ = 1, 4 do
              suffix = suffix .. string.char(math.random(65, 90))
            end
          end
          return date .. "-" .. suffix
        end,
        wiki_link_func = require("obsidian.builtin").wiki_link_path_only,
        link = {
          style = "wiki",
          auto_update = true,
        },
        open_notes_in = "current",
        frontmatter = {
          enabled = true,
          func = function(note)
            local out = { title = note.title, id = note.id, aliases = note.aliases, tags = note.tags }
            out.created_at = os.date("%Y-%m-%dT%H:%M")
            out.modified_at = os.date("%Y-%m-%dT%H:%M")
            if note.metadata ~= nil then
              for k, v in pairs(note.metadata) do
                out[k] = v
              end
            end
            return out
          end,
        },
        templates = {
          folder = "templates",
          date_format = "%Y-%m-%d",
          time_format = "%H:%M",
        },
        completion = {
          match_case = false,
          min_chars = 2,
        },
        picker = {
          name = "telescope.nvim",
          note_mappings = {
            new = "<C-x>",
            insert_link = "<C-l>",
          },
          tag_mappings = {
            tag_note = "<C-x>",
            insert_tag = "<C-l>",
          },
        },
        daily_notes = {
          enabled = true,
          folder = "calendar/daily",
          template = "~/documents/vivere/templates/daily.md",
          workdays_only = true,
        },
        attachments = {
          folder = "assets",
        },
      }
    end,
  },
  {
    "nvim-orgmode/orgmode",
    ft = { "org" },
    dependencies = { "danilshvalov/org-modern.nvim" },
    keys = {
      {
        "<leader>oa",
        function()
          require("orgmode").action("agenda.prompt")
        end,
        desc = "org-Agenda",
      },
      {
        "<leader>oc",
        function()
          require("orgmode").action("capture.prompt")
        end,
        desc = "org-Capture",
      },
    },
    opts = function()
      local Menu = require("org-modern.menu")
      return {
        ui = {
          menu = {
            handler = function(data)
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
        org_agenda_files = { "~/documents/vivere/org/**/*" },
        org_default_notes_file = "~/documents/vivere/org/refile.org",
        notifications = {
          enabled = true,
          deadline_warning_reminder_time = true,
          reminder_time = { 0, 10, 30, 60 },
        },
        org_agenda_min_height = 22,
        org_agenda_text_search_extra_files = { "agenda-archives" },
        org_capture_templates = {
          t = {
            description = "Task",
            template = "* TODO %?\n  %U\n  %a",
            target = "~/documents/vivere/org/todo.org",
          },
          n = {
            description = "Note",
            template = "* %?\n  %U\n  %a",
            target = "~/documents/vivere/org/refile.org",
          },
          j = {
            description = "Journal",
            template = "\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?",
            target = "~/documents/vivere/org/journal.org",
          },
          e = "Event",
          er = {
            description = "Reccuring Event",
            headline = "Recurring",
            template = "* %? :EVENT:\n SCHEDULED: %^T\n  %a",
            target = "~/documents/vivere/org/events.org",
          },
          eo = {
            description = "one-time Event",
            headline = "One-Time",
            template = "* %? :EVENT:\n SCHEDULED: %^T\n  %a",
            target = "~/documents/vivere/org/events.org",
          },
          m = "Meeting",
          mr = {
            description = "Reccuring Meeting",
            headline = "Recurring",
            template = "* %? :MEETING:\n SCHEDULED: %^T",
            target = "~/documents/vivere/org/meetings.org",
          },
          mo = {
            description = "one-time Meeting",
            headline = "One-Time",
            template = "* %? :MEETING:\n SCHEDULED: %^T",
            target = "~/documents/vivere/org/meetings.org",
          },
        },
      }
    end,
  },
}
