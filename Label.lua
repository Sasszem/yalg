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

function Label:getContentDimensions()
    local font = self:getFont()
    local w = font:getWidth(self.text)
    local h = font:getHeight()
    return w, h
end

function Label:draw()
    WidgetBase.draw(self)
    -- center text horizontally & vertically
    local bX, bY, bW, bH = self:getContentBox()
    local w, h = self:getContentDimensions()
    local x, y = centerBox(bX, bY, bW, bH, w, h)

    -- draw text
    love.graphics.setFont(self:getFont())
    love.graphics.setColor(self.style.textColor)
    love.graphics.print(self.text, x, y)
end


return Label
