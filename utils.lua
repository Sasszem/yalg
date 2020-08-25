local utils = {}

local os = love.system.getOS()
utils.mobile = os=="Android" or os=="iOS"

function utils.rgb(r, g, b, a)
    a = a or 255
    return {r/255, g/255, b/255, a/255}
end

local ids = {}
function utils.getId(type)
    ids[type] = (ids[type] or 0) + 1
    return type.."#"..tostring(ids[type])
end

function utils.centerBox(bX, bY, bW, bH, w, h)
    -- center a rect (w, h) inside a box
    local x = bX + (bW-w)/2
    local y = bY + (bH-h)/2
    return x, y
end

local cache = {}

function utils.Font(size, file, hinting)
    hinting = hinting or "normal"
    local fileN = (file or "DEFAULT")..hinting
    if cache[size] then
        if cache[size][fileN] then
            return cache[size][fileN]
        end
    end
    local f
    if file then
        f = love.graphics.newFont(file, size, hinting)
    else
        f = love.graphics.newFont(size, hinting)
    end
    if not cache[size] then
        cache[size] = {}
    end
    cache[size][fileN] = f
    return f
end

return utils