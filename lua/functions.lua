local funcs = {}
AddAutocommands = function(definitions)
	-- Create autocommand groups based on the passed definitions
	--
	-- The key will be the name of the group, and each definition
	-- within the group should have:
	--    1. Trigger
	--    2. Pattern
	--    3. Text
	-- just like how they would normally be defined from Vim itself
	for group_name, definition in pairs(definitions) do
		vim.cmd("augroup " .. group_name)
		vim.cmd("autocmd!")
		for _, def in pairs(definition) do
			local command = table.concat(vim.tbl_flatten({ "autocmd", def }), " ")
			vim.cmd(command)
		end
		vim.cmd("augroup END")
	end
end

RegisterKeys = function(keys)
	local isOk, which_key = pcall(require, "which-key")
	if not isOk then
		return
	end
	which_key.register(keys)
end

--- Check if a directory exists in this path
function IsDir(path)
	-- "/" works on both Unix and Windows
	return Exists(path .. "/")
end

--- Check if a file or directory exists in this path
function Exists(file)
	local ok, err, code = os.rename(file, file)
	if not ok then
		if code == 13 then
			-- Permission denied, but it exists
			return true
		end
	end
	return ok, err
end

function funcs.reload_config()
	vim.cmd("source ~/.config/nvim/init.lua")
	vim.cmd(":PackerSync")
end

-- print stuff
P = function(v)
	print(vim.inspect(v))
	return v
end

-- reload modules
if pcall(require, "plenary") then
	RELOAD = require("plenary.reload").reload_module

	R = function(name)
		RELOAD(name)
		return require(name)
	end
end

-- misc
Pyflyby = function()
    local cmd = "!tidy-imports --quiet --align-imports=0 --replace-star-imports --action REPLACE %"
		vim.api.nvim_exec(cmd, true)
end

function funcs.file_exists(name)
	local f = io.open(name, "r")
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end

function funcs.check_lsp_client_active(name)
	local clients = vim.lsp.get_active_clients()
	for _, client in pairs(clients) do
		if client.name == name then
			return true
		end
	end
	return false
end

return funcs