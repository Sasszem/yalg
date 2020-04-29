local WidgetBase = require("WidgetBase")

local Label = WidgetBase:extend()
Label.type = "Label"

Label.baseStyle = {
    textColor = rgb(255, 255, 255),
    backgroundColor = rgb(0,0,0,0),
    placement = "fill",
}

function Label:new(text, style)
    self.text = text
    self.style = style or {}
    setmetatable(self.style, {__index = self.baseStyle})
    self.id = self.style.id or getId(self.type)
end


function Label:getMinDimensions()
    local font = self:getFont()
    local w = font:getWidth(self.text)
    local h = font:getHeight()
    return w, h
end


function Label:calculateGeometry(x, y, w, h)
    if self.style.placement=="center" then
        local wS, hS = self:getMinDimensions()
        self.x = x + (w-wS)/2
        self.y = y + (h-hS)/2
        self.w = wS
        self.h = hS
    else
        self.x = x
        self.y = y
        self.w = w
        self.h = h
    end
end


function Label:draw()
    local wL, hL = self:getMinDimensions()
    love.graphics.setColor(self.style.backgroundColor)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    local x = self.x + (self.w - wL)/2
    local y = self.y + (self.h - hL)/2
    love.graphics.setColor(self.style.textColor)
    love.graphics.setFont(self:getFont())
    love.graphics.print(self.text, x, y)
end


return Label
