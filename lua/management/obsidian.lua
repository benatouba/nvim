local obsidian_ok, obsidian = pcall(require, "obsidian")
if not obsidian_ok then
  vim.notify("obsidian not okay")
  return
end

local wk_ok, wk = pcall(require, "which-key")
if not wk_ok then
  vim.notify("which-key not okay in obsidian")
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
      if note.metadata ~= nil and require("obsidian").util.table_length(note.metadata) > 0 then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end
      return out
    end,
  })

  wk.add({
    -- { "<localleader>of", "<cmd>Obsidian follow_link<CR>", desc = "Follow link", remap = false },
    { "<leader>od", "<cmd>Obsidian dailies<CR>", desc = "Dailies", remap = false },
    { "<leader>on", "<cmd>Obsidian new<CR>", desc = "New note", remap = false },
    { "<leader>oN", "<cmd>Obsidian new_from_template<CR>", desc = "New note from Template", remap = false },
    { "<leader>ot", "<cmd>Obsidian today<CR>", desc = "Today note", remap = false },
    { "<leader>oT", "<cmd>Obsidian tomorrow<CR>", desc = "Tomorrow note", remap = false },
    { "<leader>ov", "<cmd>Obsidian workspace vivere<CR>", desc = "Vivere (Workspace)", remap = false },
    { "<leader>ow", "<cmd>Obsidian workspace work<CR>", desc = "Work (Workspace)", remap = false },
    { "<leader>oy", "<cmd>Obsidian yesterday<CR>", desc = "Yesterday note", remap = false },
    { "<leader>v", group = "+Vivere", icon = { icon = "󰇈 ", color = "purple" }, remap = false },
    { "<localleader>o", group = "+Obsidian", icon = { icon = "󰇈 ", color = "purple" }, mode = { "n", "v" } },
    { "<localleader>ob", "<cmd>Obsidian backlinks<CR>", desc = "Backlinks", remap = false },
    { "<localleader>ol", "<cmd>Obsidian links<CR>", desc = "Links", remap = false },
    { "<localleader>oo", "<cmd>Obsidian open<CR>", desc = "Open in Obsidian", remap = false },
    { "<localleader>op", "<cmd>Obsidian paste_img<CR>", desc = "Paste image", remap = false },
    { "<localleader>or", "<cmd>Obsidian rename<CR>", desc = "Rename", remap = false },
    { "<localleader>os", "<cmd>Obsidian quick_switch<CR>", desc = "Quick switch", remap = false },
    { "<localleader>ot", "<cmd>Obsidian tags<CR>", desc = "Tags", remap = false },
    { "<localleader>oT", "<cmd>Obsidian template<CR>", desc = "Template", remap = false },
  })
end

return M
