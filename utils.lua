function rgb(r, g, b, a)
    local a = a or 255
    return {r/255, g/255, b/255, a/255}
end

-- merge many tables into one
-- first table has priority
-- used for style inheritance
function mergeTables(...)
    local result = {}
    local args = {...}
    for _, t in ipairs(args) do
        for k, v in pairs(t) do
            result[k] = result[k] or v
        end
    end
    return result
end