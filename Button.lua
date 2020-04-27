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

function Button:calculateStyle()
    self.cStyle = mergeTables(self.style, self.parent.style, self.baseStyle)
end

function Button:setParent(parent)
    self.parent = parent
end

function Button:getDimensions()
    local w, h = self:getRawDimensions()
    local d = 2*self.cStyle.border + 2*self.cStyle.margin
    return w+d, h+d
end

function Button:getRawDimensions()
    return self.cStyle.font:getWidth(self.text), self.cStyle.font:getHeight()
end


function Button:draw(x, y, w, h)
    if self.cStyle.placement=="center" then
        local wB, hB = self:getDimensions()
        x = x + (w-wB)/2
        y = y + (h-hB)/2
        w = wB
        h = hB
    end

    -- draw background
    love.graphics.setColor(self.cStyle.borderColor)
    love.graphics.rectangle("fill", x, y, w, h)
    love.graphics.setColor(self.cStyle.backgroundColor)
    love.graphics.rectangle("fill", x+self.cStyle.border, y+self.cStyle.border, w-2*self.cStyle.border, h-2*self.cStyle.border)
    love.graphics.setColor(self.cStyle.textColor)

    -- center horizontally & vertically
    local wB, hB = self:getRawDimensions()
    local xt = x+(w-wB)/2
    local yt = y+(h-hB)/2
    love.graphics.setFont(self.cStyle.font)
    love.graphics.print(self.text, xt, yt)
end

Button.__call = Button.new
Button.__index = Button
setmetatable(Button, Button)

return Button