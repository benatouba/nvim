-- these are all of the default values
local M = {}

M.setup = function()
    local isOk, project = pcall(require, 'project_nvim')
    if not isOk then
        print('Project.nvim not okay')
    end

    project.setup { }
    require('telescope').load_extension('projects')
end

return M
