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

return Font