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

M.config = function ()
  obsidian.setup({
    -- dir = "~/documents/vivere",
    workspaces = {
      {
        name = "vivere",
        path = "~/documents/vivere",
      },
      {
        name = "work",
        path = "~/projects/fg_doku",
      }
    },
    daily_notes = { folder = "~/documents/vivere/calendar/daily" },
    templates = {
      folder = "~/documents/vivere/templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },
    completion = {
      blink = true,
      min_chars = 3,
    },
    picker = {
      name = "telescope.nvim",
      mappings = {
        new = "<C-x>",
        insert_link = "<C-l>",
      },
    },
    note_id_func = function (title)
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
    note_frontmatter_func = function (note)
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
  vim.keymap.set(
    "n",
    "gf",
    function ()
      if require("obsidian").util.cursor_on_markdown_link() then
        return "<cmd>ObsidianFollowLink<CR>"
      else
        return "gf"
      end
    end,
    { noremap = false, expr = true }
  )
  wk.add({
    { "<leader>v", group = "+Vivere", icon = { icon = "󰇈 ", color = "purple" }, remap = false, mode = { "n", "v" } },
    { "<leader>vT", "<cmd>ObsidianTemplate<CR>", desc = "Template", remap = false },
    { "<leader>vb", "<cmd>ObsidianBacklinks<CR>", desc = "Backlinks", remap = false },
    { "<leader>vf", "<cmd>ObsidianFollowLink<CR>", desc = "Follow link", remap = false },
    { "<leader>vn", "<cmd>ObsidianNew<CR>", desc = "New note", remap = false },
    { "<leader>vN", "<cmd>ObsidianNewFromTemplate<CR>", desc = "New note from Template", remap = false },
    { "<leader>vo", "<cmd>ObsidianOpen<CR>", desc = "Open Obsidian", remap = false },
    { "<leader>vp", "<cmd>ObsidianPasteImg<CR>", desc = "Paste image", remap = false },
    { "<leader>vq", "<cmd>ObsidianQuickSwitch<CR>", desc = "Quick switch", remap = false },
    { "<leader>vr", "<cmd>ObsidianRename<CR>", desc = "Rename", remap = false },
    { "<leader>vs", group = "+Search", remap = false, icon = { icon = "󰇈 ", color = "purple" } },
    { "<leader>vsd", "<cmd>ObsidianDailies<CR>", desc = "Dailies", remap = false },
    { "<leader>vsl", "<cmd>ObsidianLinks<CR>", desc = "Links", remap = false },
    { "<leader>vss", "<cmd>ObsidianSearch<CR>", desc = "Search", remap = false },
    { "<leader>vst", "<cmd>ObsidianTags<CR>", desc = "Tags", remap = false },
    { "<leader>vt", "<cmd>ObsidianToday<CR>", desc = "Today", remap = false },
    { "<leader>vv", "<cmd>ObsidianWorkspace vivere<CR>", desc = "Vivere (Workspace)", remap = false },
    { "<leader>vw", "<cmd>ObsidianWorkspace work<CR>", desc = "Work (Workspace)", remap = false },
    { "<leader>vy", "<cmd>ObsidianYesterday<CR>", desc = "Yesterday", remap = false },
    { "<leader>vl", "<cmd>ObsidianLink<CR>", desc = "Link", mode = "v", remap = false },
  })
end

return M
