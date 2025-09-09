local obsidian_ok, obsidian = pcall(require, "obsidian")
if not obsidian_ok then
  vim.notify("obsidian not okay")
  return
end

local M = {}

M.config = function()
  ---@module 'obsidian'
  ---@type obsidian.config.ClientOpts
  obsidian.setup({
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
    notes_subdir = "notes",
    new_notes_location = "notes",
    daily_notes = {
      folder = "calendar/daily",
      template = "~/documents/vivere/templates/daily.md",
      workdays_only = true,
    },
    completion = {
      blink = true,
      nvim_cmp = false,
      match_case = false,
      min_chars = 2,
    },
    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },
    picker = {
      name = "telescope.nvim",
    },
    note_id_func = function(title)
      local suffix = ""
      if title ~= nil then
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return suffix
    end,
    wiki_link_func = "prepend_note_id",
    preferred_link_style = "wiki",
    note_frontmatter_func = function(note)
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
  })
end
return M
