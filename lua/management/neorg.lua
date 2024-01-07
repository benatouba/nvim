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

local function imports()
  return require("luasnip"), require("neorg.modules.external.templates.default_snippets")
end

local my_keys = {
  TODAY_OF_FILE_ORG = function ()  -- detect date from filename and return in org date format
    local ls, m = imports()
    -- use m.file_name_date() if you use journal.strategy == "flat"
    return ls.text_node(m.parse_date(0, m.file_tree_date(), [[<%Y-%m-%d %a]]))  -- <2006-11-01 Wed>
  end,
  TODAY_OF_FILE_NORG = function ()  -- detect date from filename and return in norg date format
    local ls, m = imports()
    -- use m.file_name_date() if you use journal.strategy == "flat"
    return ls.text_node(m.parse_date(0, m.file_tree_date(), [[%a, %d %b %Y]]))  -- Wed, 1 Nov 2006
  end,
  TODAY_ORG = function ()  -- detect date from filename and return in org date format
    local ls, m = imports()
    return ls.text_node(m.parse_date(0, os.time(), [[<%Y-%m-%d %a %H:%M:%S>]]))  -- <2006-11-01 Wed 19:15>
  end,
  TODAY_NORG = function ()  -- detect date from filename and return in norg date format
    local ls, m = imports()
    return ls.text_node(m.parse_date(0, os.time(), [[%a, %d %b %Y %H:%M:%S]]))  -- Wed, 1 Nov 2006 19:15
  end,
  NOW_IN_DATETIME = function ()  -- print current date+time of invoke
    local ls, m = imports()
    return ls.text_node(m.parse_date(0, os.time(), [[%Y-%m-%d %a %X]]))  -- 2023-11-01 Wed 23:48:10
  end,
}

local function isLineStartingWithHyphenOrWhitespace()
    local line = vim.fn.getline('.')
    return line:match('^%s*%- (') ~= nil
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'norg',
  callback = function()
    M.insertHyphenParentheses()
  end
})

function M.insertHyphenParentheses()
    if isLineStartingWithHyphenOrWhitespace() then
        vim.api.nvim_command('normal! o- ( )')
    else
        vim.api.nvim_command('normal! o')
    end
end


neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function (_, keybinds)
  keybinds.map_event_to_mode("norg", {
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
      ["core.keybinds"] = {
        config = {
          default_keybinds = true,
          neorg_leader = "<localleader>",
        },
      },
      ["external.templates"] = {
        config = {
          templates_dir = vim.fn.stdpath("config") .. "/templates/norg",
          keywords = my_keys,
        },
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
      W = { "<cmd>Neorg return<CR>", "Return" },
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
