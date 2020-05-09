function rgb(r, g, b, a)
    local a = a or 255
    return {r/255, g/255, b/255, a/255}
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

local cache = {}

function Font(size, file)
    local fileN = file or "DEFAULT"
    if cache[size] then
        if cache[size][fileN] then
            return cache[size][fileN]
        end
    end
    local f = love.graphics.newFont(size, file)
    if not cache[size] then
        cache[size] = {}
    end
    cache[size][fileN] = f
    return f
end