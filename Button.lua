require("utils")

local Button = {
    type="Button",
    placement = "fill",
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

function Button:getMinDimensions()
    local w, h = self:getRawDimensions()
    local d = 2*self.cStyle.border + 2*self.cStyle.margin
    return w+d, h+d
end

function Button:calculateGeometry(x, y, w, h)
    if self.cStyle.placement=="center" then
        local wS, hS = self:getMinDimensions()
        wS = wS - 2*self.cStyle.margin
        hS = hS - 2*self.cStyle.margin
        self.x = x + (w-wS)/2
        self.y = y + (h-hS)/2
        self.w = wS
        self.h = hS
    else
        self.x = x + self.cStyle.margin
        self.y = y + self.cStyle.margin
        self.w = w - 2*self.cStyle.margin
        self.h = h - 2*self.cStyle.margin
    end
end

function Button:getRawDimensions()
    return self.cStyle.font:getWidth(self.text), self.cStyle.font:getHeight()
end


function Button:draw()
    -- draw background
    love.graphics.setColor(self.cStyle.borderColor)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setColor(self.cStyle.backgroundColor)
    love.graphics.rectangle("fill", self.x+self.cStyle.border, self.y+self.cStyle.border, self.w-2*self.cStyle.border, self.h-2*self.cStyle.border)
    love.graphics.setColor(self.cStyle.textColor)

    -- center horizontally & vertically
    local wB, hB = self:getRawDimensions()
    local xt = self.x+(self.w-wB)/2
    local yt = self.y+(self.h-hB)/2
    love.graphics.setFont(self.cStyle.font)
    love.graphics.print(self.text, xt, yt)
end

Button.__index = Button
setmetatable(Button, {__call = Button.new})

return Button