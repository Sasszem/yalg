local Label = {
    type="Label"
}

Label.baseStyle = {
    textColor = rgb(255, 255, 255),
    backgroundColor = rgb(0,0,0,0),
    placement = "fill",
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


function Label:getMinDimensions()
    local w = self.cStyle.font:getWidth(self.text)
    local h = self.cStyle.font:getHeight()
    return w, h
end


function Label:calculateGeometry(x, y, w, h)
    if self.cStyle.placement=="center" then
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
    love.graphics.setColor(self.cStyle.backgroundColor)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    local x = self.x + (self.w - wL)/2
    local y = self.y + (self.h - hL)/2
    love.graphics.setColor(self.cStyle.textColor)
    love.graphics.setFont(self.cStyle.font)
    love.graphics.print(self.text, x, y)
end

Label.__index = Label
setmetatable(Label, {__call = Label.new})

return Label
