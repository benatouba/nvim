local neorg_ok, neorg = pcall(require, "neorg")
if not neorg_ok then
  vim.notify("neorg not ok")
  return
end

local which_key_ok, wk = pcall(require, "which-key")
if not which_key_ok then
  vim.notify("which-key not ok in neorg")
  return
end

local M = {}

local neorg_callbacks = require("neorg.core.callbacks")

neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function (_, keybinds)
  -- Map all the below keybinds only when the "norg" mode is active
  keybinds.map_event_to_mode("norg", {
    n = {  -- Bind keys in normal mode
      { "<leader>oO", "core.integrations.telescope.find_linkable" },
    },
    i = {  -- Bind in insert mode
      { "<C-l>", "core.integrations.telescope.insert_link" },
    },
  }, {
    silent = true,
    noremap = true,
  })
end)

M.config = function ()
  neorg.setup({
    load = {
      ["core.defaults"] = {},  -- Loads default behaviour
      ["core.concealer"] = {
        config = {
          icons = {
            todo = {
              undone = {
                icon = " ",
              }
            }
          }
        }
      },  -- Adds pretty icons to your documents
      ["core.completion"] = { config = { engine = "nvim-cmp", name = " Neorg" } },
      ["core.dirman"] = {  -- Manages Neorg workspaces
        config = {
          workspaces = {
            base = "~/documents/vivere",
            projects = "~/documents/vivere/00_projects",
            ideas = "~/documents/vivere/04_ideas",
            tech = "~/documents/vivere/02_tech",
            people = "~/documents/vivere/06_people",
          },
          default_workspace = "base",
        },
      },
      ["core.export"] = {},
      ["core.export.markdown"] = {},
      ["core.integrations.nvim-cmp"] = {},  -- Allows for use of telescope
      ["core.integrations.telescope"] = {},  -- Allows for use of telescope
      ["core.integrations.treesitter"] = {},  -- Allows for use of treesitter
      ["core.esupports.metagen"] = {
        config = {
          type = "auto",
        }
      },
      ["core.qol.toc"] = {
        config = {
          close_after_use = true,
        },
      },
      ["core.summary"] = {},
      ["core.ui.calendar"] = {},
      ["external.context"] = {},
      ["external.templates"] = {
        config = {
          templates_dir = vim.fn.stdpath("config") .. "/snippets/templates/norg/"
        }
      },
    }
  })
  local maps = {
    -- o is for organising
    o = {
      name = "+Org",
      b = { "<cmd>Neorg workspace base<CR>", "Base" },
      i = { "<cmd>Neorg workspace ideas<CR>", "Ideas" },
      t = { "<cmd>Neorg workspace tech<CR>", "Tech" },
      p = { "<cmd>Neorg workspace people<CR>", "People" },
      w = { "<cmd>Neorg workspace projects<CR>", "Work (Projects)" },
    },
  }
  local locmaps = {
    c = { "<cmd>Neorg toc<CR>", "Contents" },
  }

  wk.register(maps, {
    mode = "n",  -- NORMAL mode
    prefix = "<leader>",
  })

  wk.register(locmaps, {
    mode = "n",  -- NORMAL mode
    prefix = "<localleader>",
  })
end

return M
