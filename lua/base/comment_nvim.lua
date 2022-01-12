local comment_ok, comment = pcall(require, "Comment")
-- local tsc_ok, tsc = pcall(require, "ts_context_commentstring.utils")
if not comment_ok then
	P("Comment.nvim not ok")
	return
end
local wk = require("which-key")

local M = {}

local mappings_n = {
	["/"] = { "<cmd>lua require('Comment.api').toggle()<CR>", "Comment Line" },
}
local mappings = {
	["c"] = {
		name = "+Comment",
		c = "Line Comment",
		o = "Comment New Line",
		O = "Comment New Line Above Cursor",
		A = "Comment at End of Line",
	},
	["b"] = {
		name = "+Block Comment",
		c = "Comment",
	},
}

local opts = {}
-- NOTE: Seems to work fine without this. Reactivate if necessary
--[[ if O.language_parsing == true and tsc_ok then
    ---@param ctx Ctx
    opts.pre_hook = function(ctx)
        -- Only calculate commentstring for tsx filetypes
        if vim.bo.filetype == 'typescriptreact' then or vim.bo.filetype == 'vue' then
            local U = require('Comment.utils')

            -- Detemine whether to use linewise or blockwise commentstring
            local type = ctx.ctype == U.ctype.line and '__default' or '__multiline'

            -- Determine the location where to calculate commentstring from
            local location = nil
            if ctx.ctype == U.ctype.block then
                location = tsc.get_cursor_location()
            elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
                location = tsc.get_visual_start_location()
            end

            return require('ts_context_commentstring.internal').calculate_commentstring({
                key = type,
                location = location,
            })
        end
    end
end ]]

M.config = function()
	comment.setup(opts)
	wk.register(mappings, { prefix = "g" })
	wk.register(mappings_n, { prefix = "<leader>" })
end

return M
