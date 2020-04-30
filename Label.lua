local WidgetBase = require("WidgetBase")

local Label = WidgetBase:extend()
Label.type = "Label"

Label.baseStyle = {
}
setmetatable(Label.baseStyle, {__index=WidgetBase.baseStyle})

function Label:new(text, style)
    self.text = text
    WidgetBase.new(self, style)
end

function Label:getRawDimensions()
    local font = self:getFont()
    local w = font:getWidth(self.text)
    local h = font:getHeight()
    return w, h
end

function Label:draw()
    WidgetBase.draw(self)
    -- center text horizontally & vertically
    local wB, hB = self:getRawDimensions()
    local xt = self.x+(self.w-wB)/2
    local yt = self.y+(self.h-hB)/2

    -- draw text
    love.graphics.setFont(self:getFont())
    love.graphics.setColor(self.style.textColor)
    love.graphics.print(self.text, xt, yt)
end


return Label
