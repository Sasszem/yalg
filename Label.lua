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
    -- copy the styles into self styles
    for k, v in pairs(parent.style) do
        self.style[k] = self.style[k] or v
    end

    -- copy base style into self
    for k, v in pairs(self.baseStyle) do
        self.style[k] = self.style[k] or v
    end
end


function Label:getMinimumDimensions()
    self.w = self.style.font:getWidth(self.text)
    self.h = self.style.font:getHeight()
    return self.w, self.h
end

function Label:draw(x, y, w, h)
    local wL, hL = self:getMinimumDimensions()
    local x = x + (w - wL)/2
    local y = y + (h - hL)/2
    love.graphics.setColor(self.style.textColor)
    love.graphics.setFont(self.style.font)
    love.graphics.print(self.text, x, y)
end

Label.__call = Label.new
Label.__index = Label
setmetatable(Label, Label)

return Label
