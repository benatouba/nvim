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
-- local parser_config = tsp.get_parser_configs()
-- parser_config.org = {
-- 	install_info = {
-- 		url = "https://github.com/milisims/tree-sitter-org",
-- 		revision = "main",
-- 		files = { "src/parser.c", "src/scanner.cc" },
-- 	},
-- 	filetype = "org",
-- }

-- org.setup_ts_grammar()
tsc.setup({
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { "org" },  -- Required since TS highlighter doesn't support all syntax features (conceal)
  },
  ensure_installed = { "org" },  -- Or run :TSUpdate org
})
org.setup({
  org_agenda_files = { "~/documents/vivere/org/*", },
  org_default_notes_file = "~/documents/vivere/org/refile.org",
  org_timestamp_rounding_minutes = 15,
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
    m = {
      description = "Meeting",
      template = "* MEETING with %? :MEETING:\n  %U",
      target = "~/documents/vivere/org/meetings.org"
    },
  }
})

local maps = {
  { "<leader>o", group = "Org", nowait = false, remap = false, icon = { icon = "", color = "purple" } },
  { "<leader>oa", "<cmd>lua require('orgmode').action('agenda.prompt')<CR>", desc = "org-Agenda", nowait = false, remap = false },
  { "<leader>oc", "<cmd>lua require('orgmode').action('capture.prompt')<CR>", desc = "org-Capture", nowait = false, remap = false },
}

local isOk, which_key = pcall(require, "which-key")
if not isOk then
  vim.notify("which-key not okay in orgmode", vim.log.levels.ERROR)
  return
end
which_key.add(maps)
