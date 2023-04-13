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
	obsidian.setup({
		dir = "~/documents/vivere",
		completion = { nvim_cmp = true },
		daily_notes = { folder = "Day Planners" },
		templates = {
			subdir = "templates",
			date_format = "%Y-%m-%d-%a",
			time_format = "%H:%M",
		},
		note_id_func = function(title)
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
			return tostring(os.time()) .. "-" .. suffix
		end,
		note_frontmatter_func = function(note)
			local out = { id = note.id, aliases = note.aliases, tags = note.tags }
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
		function()
			if require('obsidian').util.cursor_on_markdown_link() then
				return "<cmd>ObsidianFollowLink<CR>"
			else
				return "gf"
			end
		end,
		{ noremap = false, expr = true }
	)
	local opts = { mode = 'n', prefix = "<leader>", silent = true, noremap = true }
	local maps = {
		v = {
			name = "Vivere",
			b = { "<cmd>ObsidianBacklinks<CR>", "Backlinks" },
			f = { "<cmd>ObsidianFollowLink<CR>", "Follow link" },
			l = { "<cmd>ObsidianLink<CR>", "Link" },
			n = { "<cmd>ObsidianNew<CR>", "New note" },
			o = { "<cmd>ObsidianOpen<CR>", "Open Obsidian" },
			q = { "<cmd>ObsidianQuickSwitch<CR>", "Quick switch" },
			s = { "<cmd>ObsidianSearch<CR>", "Search" },
			t = { "<cmd>ObsidianToday<CR>", "Today" },
			T = { "<cmd>ObsidianTemplate<CR>", "Template" },
			y = { "<cmd>ObsidianYesterday<CR>", "Yesterday" },
		}
	}
	wk.register(maps, opts)
end

return M