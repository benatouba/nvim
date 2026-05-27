return {
  {
    "nvim-neotest/neotest",
    keys = {
      { "<leader>tA", "<cmd>lua require('neotest').state.adapter_ids()<CR>", desc = "Adapters" },
      {
        "<leader>tD",
        "<cmd>lua require('neotest').run.run({ vim.fn.expand('%'), strategy = 'dap' })<CR>",
        desc = "Debug File",
      },
      { "<leader>tL", "<cmd>lua require('neotest').run.run_last({ strategy = 'dap' })<CR>", desc = "Last (Debug)" },
      {
        "<leader>tO",
        "<cmd>lua require('neotest').output.open({ enter = true, short = true, last_run = true })<CR>",
        desc = "Output (short)",
      },
      { "<leader>tP", "<cmd>lua require('test.neotest').NeotestSetupProject()<CR>", desc = "Project" },
      { "<leader>tS", "<cmd>lua require('neotest').run.run({ suite = true })<CR>", desc = "Suite" },
      { "<leader>ta", "<cmd>lua require('neotest').run.attach()<CR>", desc = "Attach to nearest" },
      { "<leader>td", "<cmd>lua require('neotest').run.run({ strategy = 'dap' })<CR>", desc = "Debug" },
      { "<leader>tf", "<cmd>lua require('neotest').run.run({ vim.fn.expand('%') })<CR>", desc = "File" },
      { "<leader>tl", "<cmd>lua require('neotest').run.run_last()<CR>", desc = "Last" },
      { "<leader>tj", group = "+Jump" },
      {
        "<leader>tjp",
        "<cmd>lua require('neotest').jump.prev({ status = 'failed' })<CR>",
        desc = "Previous (failed)",
      },
      { "<leader>tjn", "<cmd>lua require('neotest').jump.next({ status = 'failed' })<CR>", desc = "Next (failed)" },
      { "<leader>tn", "<cmd>lua require('neotest').run.run()<CR>", desc = "Nearest" },
      { "<leader>to", "<cmd>lua require('neotest').output.open({ enter = true })<CR>", desc = "Output" },
      { "<leader>tp", "<cmd>lua require('neotest').output_panel.toggle()<CR>", desc = "Panel" },
      { "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<CR>", desc = "Summary" },
      { "<leader>tt", "<cmd>lua require('neotest').run.run({ suite = true})<CR>", desc = "Run Tests" },
      { "<leader>tw", "<cmd>lua require('neotest').watch.toggle()<CR>", desc = "Watch" },
      { "<leader>tx", "<cmd>lua require('neotest').run.stop()<CR>", desc = "Stop" },
    },
    dependencies = {
      "nvim-neotest/neotest-python",
      "shunsambongi/neotest-testthat",
      "marilari88/neotest-vitest",
      "nvim-neotest/neotest-jest",
      { "thenbe/neotest-playwright", dependencies = { "nvim-neotest/neotest" } },
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("test.neotest").config()
    end,
    enabled = O.test,
  },
  { "nvim-neotest/nvim-nio" },
}
