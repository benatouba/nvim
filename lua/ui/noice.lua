local M = {}

M.config = function()
  local status_ok, noice = pcall(require, "noice")
  if not status_ok then
    vim.notify("noice not ok", vim.log.levels.ERROR)
    return
  end
  noice.setup({
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      hover = {
        enabled = true,
      },
      signature = {
        enabled = true,
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = false, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = true, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = true, -- add a border to hover docs and signature help
    },
    cmdline = {
      enabled = true,
      view = "cmdline",
    },
    routes = {
      {
        filter = {
          event = "msg_show",
          kind = "search_count",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "written",
        },
        opts = { skip = true },
      },
       {
        filter = {
          event = "notify",
          min_height = 15
        },
        view = 'split'
      },
    },
  })
end

return M
