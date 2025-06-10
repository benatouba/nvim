local detail = false

local function parse_output(proc)
  local result = proc:wait()
  local ret = {}
  if result.code == 0 then
    for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
      -- Remove trailing slash
      line = line:gsub("/$", "")
      ret[line] = true
    end
  end
  return ret
end

-- build git status cache
local function new_git_status()
  return setmetatable({}, {
    __index = function(self, key)
      local ignore_proc = vim.system(
        { "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" },
        {
          cwd = key,
          text = true,
        }
      )
      local tracked_proc = vim.system({ "git", "ls-tree", "HEAD", "--name-only" }, {
        cwd = key,
        text = true,
      })
      local ret = {
        ignored = parse_output(ignore_proc),
        tracked = parse_output(tracked_proc),
      }

      rawset(self, key, ret)
      return ret
    end,
  })
end
local git_status = new_git_status()

-- Clear git status cache on refresh
local refresh = {
  desc = "Refresh current directory list",
  callback = function(opts)
    opts = opts or {}
    if vim.bo.modified and not opts.force then
      local ok, choice = pcall(vim.fn.confirm, "Discard changes?", "No\nYes")
      if not ok or choice ~= 2 then
        return
      end
    end
    vim.cmd.edit({ bang = true })

    -- :h CTRL-L-default
    vim.cmd.nohlsearch()
  end,
  parameters = {
    force = {
      desc = "When true, do not prompt user if they will be discarding changes",
      type = "boolean",
    },
  },
}
local orig_refresh = refresh.callback
refresh.callback = function(...)
  git_status = new_git_status()
  orig_refresh(...)
end

-- Declare a global function to retrieve the current directory
function _G.get_oil_winbar()
  local dir = require("oil").get_current_dir()
  if dir then
    return vim.fn.fnamemodify(dir, ":~")
  else
    -- If there is no current directory (e.g. over ssh), just show the buffer name
    return vim.api.nvim_buf_get_name(0)
  end
end

local M = {}
M.config = function()
  require("oil").setup({
    win_options = {
      wrap = true,
      winbar = "%!v:lua.get_oil_winbar()",
    },
    watch_for_changes = true,
    git = {
      -- Return true to automatically git add/mv/rm files
      add = function(path)
        return true
      end,
      mv = function(src_path, dest_path)
        return true
      end,
      rm = function(path)
        return true
      end,
    },
    view_options = {
      show_hidden = false,
      is_hidden_file = function(name, bufnr)
        local dir = require("oil").get_current_dir(bufnr)
        local is_dotfile = vim.startswith(name, ".") and name ~= ".."
        -- if no local directory (e.g. for ssh connections), just hide dotfiles
        if not dir then
          return is_dotfile
        end
        -- dotfiles are considered hidden unless tracked
        if is_dotfile then
          return not git_status[dir].tracked[name]
        else
          -- Check if file is gitignored
          return git_status[dir].ignored[name]
        end
      end,
      is_always_hidden = function(name, _)
        return vim.startswith(name, "..")
      end,
    },
    keymaps = {
      ["gd"] = {
        desc = "Toggle file detail view",
        callback = function()
          detail = not detail
          if detail then
            require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
          else
            require("oil").set_columns({ "icon" })
          end
        end,
      },
      ["<C-v>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
      ["<C-x>"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" },
      ["<q>"] = { "actions.close", mode = "n", desc = "Close the entry" },
      ["<esc>"] = { "<cmd>q<cr>", desc = "Close neovim" },
    },
  })
  require("which-key").add({
    { "<leader>e", ":Oil<cr>", desc = "Explorer", icon = { icon = " ", color = "yellow" } },
  })
end
return M
