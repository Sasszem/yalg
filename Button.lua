require("utils")

local Button = {
    type="Button",
}

Button.baseStyle = {
    border=3,
    borderColor=rgb(255, 0, 0),
    backgroundColor=rgb(100, 100, 100),
    textColor=rgb(255, 255, 255),
    margin=5,
}

function Button:new(text, style)
    local o = {}
    setmetatable(o, Button)
    o.text = text
    o.style = style or {}
    return o
end

function Button:setParent(parent)
    -- copy the styles into self styles
    for k, v in pairs(parent.style) do
        self.style[k] = self.style[k] or v
    end

    -- copy base style into self
    for k, v in pairs(self.baseStyle) do
        self.style[k] = self.style[k] or v
    end
end

function Button:getDimensions()
    local w, h = self:getRawDimensions()
    local d = 2*self.style.border + 2*self.style.margin
    return w+d, h+d
end

function Button:getRawDimensions()
    return self.style.font:getWidth(self.text), self.style.font:getHeight()
end


function Button:draw(x, y, w, h)
    if self.style.placement=="center" then
        local wB, hB = self:getDimensions()
        x = x + (w-wB)/2
        y = y + (h-hB)/2
        w = wB
        h = hB
    end

    -- draw background
    love.graphics.setColor(self.style.borderColor)
    love.graphics.rectangle("fill", x, y, w, h)
    love.graphics.setColor(self.style.backgroundColor)
    love.graphics.rectangle("fill", x+self.style.border, y+self.style.border, w-2*self.style.border, h-2*self.style.border)
    love.graphics.setColor(self.style.textColor)

    -- center horizontally & vertically
    local wB, hB = self:getRawDimensions()
    local xt = x+(w-wB)/2
    local yt = y+(h-hB)/2
    love.graphics.setFont(self.style.font)
    love.graphics.print(self.text, xt, yt)
end

Button.__call = Button.new
Button.__index = Button
setmetatable(Button, Button)

return Button