local obsidian_ok, obsidian = pcall(require, "obsidian")
if not obsidian_ok then
  vim.notify("obsidian not okay")
  return
end

local M = {}

M.config = function()
  ---@module 'obsidian'
  ---@type obsidian.config.Internal
  obsidian.setup({
    legacy_commands = false,
    notes_subdir = "notes",
    new_notes_location = "current_dir",
    workspaces = {
      {
        name = "vivere",
        path = "~/documents/vivere",
      },
      {
        name = "work",
        path = "~/projects/fg_doku",
      },
    },
    note_id_func = function(title)
      local date = os.date "%Y-%m-%d"
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
    preferred_link_style = "wiki",
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
    }
  })
end
return M
