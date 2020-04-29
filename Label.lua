local WidgetBase = require("WidgetBase")

local Label = WidgetBase:extend()
Label.type = "Label"

Label.baseStyle = {
    textColor = rgb(255, 255, 255),
    backgroundColor = rgb(0,0,0,0),
    borderColor=rgb(0, 0, 0, 0),
    placement = "fill",
    border = 0,
    margin = 0,
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

function Label:getMinDimensions()
    local w, h = self:getRawDimensions()
    local d = 2*self.style.border + 2*self.style.margin
    return w+d, h+d
end


function Label:draw()
    -- draw border
    love.graphics.setColor(self.style.borderColor)
    love.graphics.setLineWidth(self.style.border)
    local b = self.style.border / 2
    love.graphics.rectangle("line", self.x + b, self.y + b, self.w - 2*b, self.h - 2*b)

    -- draw background
    love.graphics.setColor(self.style.backgroundColor)
    love.graphics.rectangle("fill", self.x+self.style.border, self.y+self.style.border, self.w-2*self.style.border, self.h-2*self.style.border)

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
