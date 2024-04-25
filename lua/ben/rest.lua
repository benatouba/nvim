local M = {}

M.config = function()
  require("rest-nvim").setup({
    -- Skip SSL verification, useful for unknown certificates
    skip_ssl_verification = false,
    -- Encode URL before making request
    encode_url = true,
    -- Highlight request on run
    highlight = {
      enable = true,
      timeout = 150,
    },
    result = {
      split = {
        horizontal = false,
        in_place = false,
        stay_in_current_window_after_split = false,
      },
      behavior = {
        show_info = {
          url = true,
          curl_command = false,
          http_info = true,
          headers = true,
        },
        -- executables or functions for formatting response body [optional]
        -- set them to false if you want to disable them
        formatters = {
          json = "jq",
          html = function(body)
            if vim.fn.executable("tidy") == 0 then
              return body, { found = false, name = "tidy" }
            end
            local fmt_body = vim.fn
              .system({
                "tidy",
                "-i",
                "-q",
                "--tidy-mark",
                "no",
                "--show-body-only",
                "auto",
                "--show-errors",
                "0",
                "--show-warnings",
                "0",
                "-",
              }, body)
              :gsub("\n$", "")

            return fmt_body, { found = true, name = "tidy" }
          end,
        },
      },
    },
    -- Jump to request line on run
    -- jump_to_request = false,
    env_file = ".env",
    custom_dynamic_variables = {},
    -- yank_dry_run = true,
    -- search_back = true,
  })

  require("which-key").register({
    R = {
      name = "+Rest",
      r = { "<Plug>RestNvim<cr>", "Rest Run" },
      p = { "<Plug>RestNvimPreview<cr>", "Rest Run Preview" },
      l = { "<Plug>RestNvimLast<cr>", "Rest Run Last" },
    },
  }, { prefix = "<leader>" })

  require("telescope").load_extension("rest")
end

return M
