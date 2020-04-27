local Font = {}

local cache = {}

function Font:new(size, file)
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

Font.__call = Font.new
setmetatable(Font, Font)

return Font