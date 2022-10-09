local M = {}

local is_table = function(table)
    return type(table) == 'table'
end

M.merge = function(...)
    local result = {}

    for _, table in ipairs({ ... }) do
        for key, value in pairs(table) do
            result[key] = value
        end
    end

    return result
end

return M