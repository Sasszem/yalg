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

local ids = {}
function getId(type)
    ids[type] = (ids[type] or 0) + 1
    return type.."#"..tostring(ids[type])
end

function centerBox(bX, bY, bW, bH, w, h)
    -- center a rect (w, h) inside a box
    local x = bX + (bW-w)/2
    local y = bY + (bH-h)/2
    return x, y
end