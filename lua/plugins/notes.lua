-- Notes: obsidian vaults (markdown) and orgmode.
return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    cmd = "Obsidian",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    keys = {
      { "<leader>od", "<cmd>Obsidian dailies<CR>", desc = "Dailies", ft = "markdown" },
      { "<leader>on", "<cmd>Obsidian new<CR>", desc = "New note", ft = "markdown" },
      { "<leader>oN", "<cmd>Obsidian new_from_template<CR>", desc = "New note from Template", ft = "markdown" },
      { "<leader>ot", "<cmd>Obsidian today<CR>", desc = "Today note", ft = "markdown" },
      { "<leader>oT", "<cmd>Obsidian tomorrow<CR>", desc = "Tomorrow note", ft = "markdown" },
      { "<leader>os", "<cmd>Obsidian search<CR>", desc = "Search Workspace", ft = "markdown" },
      { "<leader>or", "<cmd>Obsidian rename<CR>", desc = "Rename", ft = "markdown" },
      { "<leader>ov", "<cmd>Obsidian workspace vivere<CR>", desc = "Vivere (Workspace)", ft = "markdown" },
      { "<leader>ow", "<cmd>Obsidian workspace work<CR>", desc = "Work (Workspace)", ft = "markdown" },
      { "<leader>oy", "<cmd>Obsidian yesterday<CR>", desc = "Yesterday note", ft = "markdown" },
      { "<localleader>ob", "<cmd>Obsidian backlinks<CR>", desc = "Backlinks", ft = "markdown" },
      { "<localleader>ol", "<cmd>Obsidian links<CR>", desc = "Links", ft = "markdown" },
      { "<localleader>oo", "<cmd>Obsidian open<CR>", desc = "Open in Obsidian", ft = "markdown" },
      { "<localleader>op", "<cmd>Obsidian paste_img<CR>", desc = "Paste image", ft = "markdown" },
      { "<localleader>or", "<cmd>Obsidian rename<CR>", desc = "Rename", ft = "markdown" },
      { "<localleader>os", "<cmd>Obsidian quick_switch<CR>", desc = "Quick switch", ft = "markdown" },
      { "<localleader>ot", "<cmd>Obsidian tags<CR>", desc = "Tags", ft = "markdown" },
      { "<localleader>oT", "<cmd>Obsidian template<CR>", desc = "Template", ft = "markdown" },
      { "<C-Space>", "<cmd>Obsidian toggle_checkbox<CR>", desc = "Toggle Checkbox", ft = "markdown" },
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
        -- Kept save-time behavior (#8): obsidian.nvim refreshes frontmatter
        -- on BufWritePre for workspace notes (templates/blacklist excluded
        -- by the plugin). created_at is preserved; modified_at is stamped
        -- on every save. Scoped to markdown vault notes only.
        frontmatter = {
          enabled = true,
          func = function(note)
            local out = { title = note.title, id = note.id, aliases = note.aliases, tags = note.tags }
            if note.metadata ~= nil then
              for k, v in pairs(note.metadata) do
                if k ~= "modified_at" then
                  out[k] = v
                end
              end
            end
            if out.created_at == nil then
              out.created_at = os.date("%Y-%m-%dT%H:%M")
            end
            out.modified_at = os.date("%Y-%m-%dT%H:%M")
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
