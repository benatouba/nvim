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
    completion = { nvim_cmp = true },
    daily_notes = { folder = "calendar/daily" },
    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d-%a",
      time_format = "%H:%M",
    },
    picker = {
      -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
      name = "telescope.nvim",
      -- Optional, configure key mappings for the picker. These are the defaults.
      -- Not all pickers support all mappings.
      mappings = {
        -- Create a new note from your query.
        new = "<C-x>",
        -- Insert a link to the selected note.
        insert_link = "<C-l>",
      },
    },
    note_id_func = function (title)
      -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
      local suffix = ""
      if title ~= nil then
        -- If title is given, transform it into valid file name.
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        -- If title is nil, just add 4 random uppercase letters to the suffix.
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return suffix
    end,
    note_frontmatter_func = function (note)
      local out = { title = note.id, id = note.id, aliases = note.aliases, tags = note.tags }
      -- `note.metadata` contains any manually added fields in the frontmatter.
      -- So here we just make sure those fields are kept in the frontmatter.
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
    { "<leader>v", group = "+Vivere", remap = false },
    { "<leader>vT", "<cmd>ObsidianTemplate<CR>", desc = "Template", remap = false },
    { "<leader>vb", "<cmd>ObsidianBacklinks<CR>", desc = "Backlinks", remap = false },
    { "<leader>vf", "<cmd>ObsidianFollowLink<CR>", desc = "Follow link", remap = false },
    { "<leader>vn", "<cmd>ObsidianNew<CR>", desc = "New note", remap = false },
    { "<leader>vo", "<cmd>ObsidianOpen<CR>", desc = "Open Obsidian", remap = false },
    { "<leader>vp", "<cmd>ObsidianPasteImg<CR>", desc = "Paste image", remap = false },
    { "<leader>vq", "<cmd>ObsidianQuickSwitch<CR>", desc = "Quick switch", remap = false },
    { "<leader>vr", "<cmd>ObsidianRename<CR>", desc = "Rename", remap = false },
    { "<leader>vs", group = "+Obsidian", remap = false },
    { "<leader>vsd", "<cmd>ObsidianDailies<CR>", desc = "Dailies", remap = false },
    { "<leader>vsl", "<cmd>ObsidianLinks<CR>", desc = "Links", remap = false },
    { "<leader>vss", "<cmd>ObsidianSearch<CR>", desc = "Search", remap = false },
    { "<leader>vst", "<cmd>ObsidianTags<CR>", desc = "Tags", remap = false },
    { "<leader>vt", "<cmd>ObsidianToday<CR>", desc = "Today", remap = false },
    { "<leader>vv", "<cmd>ObsidianWorkspace vivere<CR>", desc = "Vivere (Workspace)", remap = false },
    { "<leader>vw", "<cmd>ObsidianWorkspace work<CR>", desc = "Work (Workspace)", remap = false },
    { "<leader>vy", "<cmd>ObsidianYesterday<CR>", desc = "Yesterday", remap = false },
    { "<leader>v", group = "+Vivere", mode = "v", remap = false },
    { "<leader>vl", "<cmd>ObsidianLink<CR>", desc = "Link", mode = "v", remap = false },
  })
end

return M
