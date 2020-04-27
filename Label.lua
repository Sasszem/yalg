local Label = {
    type="Label"
}

Label.baseStyle = {
    textColor = rgb(255, 255, 255),
}

function Label:new(text, style)
    local o = {}
    setmetatable(o, Label)
    o.text = text
    o.style = style or {}
    return o
end

function Label:setParent(parent)
    self.parent = parent
end


function Label:calculateStyle()
    self.cStyle = mergeTables(self.style, self.parent.cStyle, self.baseStyle)
end


function Label:getMinimumDimensions()
    self.w = self.cStyle.font:getWidth(self.text)
    self.h = self.cStyle.font:getHeight()
    return self.w, self.h
end


function Label:draw(x, y, w, h)
    local wL, hL = self:getMinimumDimensions()
    local x = x + (w - wL)/2
    local y = y + (h - hL)/2
    love.graphics.setColor(self.cStyle.textColor)
    love.graphics.setFont(self.cStyle.font)
    love.graphics.print(self.text, x, y)
end

Label.__index = Label
setmetatable(Label, {__call = Label.new})

return Label
