function rgb(r, g, b, a)
    local a = a or 255
    return {r/255, g/255, b/255, a/255}
end