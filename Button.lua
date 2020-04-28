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
    placement = "fill",
}

function Button:new(text, style)
    local o = {}
    setmetatable(o, Button)
    o.text = text
    o.style = style or {}
    setmetatable(o.style, {__index = o.baseStyle})
    o.id = o.style.id or getId(o.type)
    return o
end


function Button:setParent(parent)
    self.parent = parent
    self.parent:addWidgetLookup(self.id, self)
end

function Button:getMinDimensions()
    local w, h = self:getRawDimensions()
    local d = 2*self.style.border + 2*self.style.margin
    return w+d, h+d
end

function Button:calculateGeometry(x, y, w, h)
    if self.style.placement=="center" then
        local wS, hS = self:getMinDimensions()
        wS = wS - 2*self.style.margin
        hS = hS - 2*self.style.margin
        self.x = x + (w-wS)/2
        self.y = y + (h-hS)/2
        self.w = wS
        self.h = hS
    else
        self.x = x + self.style.margin
        self.y = y + self.style.margin
        self.w = w - 2*self.style.margin
        self.h = h - 2*self.style.margin
    end
end

function Button:getRawDimensions()
    local font = self:getFont()
    return font:getWidth(self.text), font:getHeight()
end

function Button:getFont()
    -- fonts are sprecial, and inherit from parent widgets to childer
    return self.style.font or self.parent:getFont()
end

function Button:draw()
    -- draw background
    love.graphics.setColor(self.style.borderColor)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setColor(self.style.backgroundColor)
    love.graphics.rectangle("fill", self.x+self.style.border, self.y+self.style.border, self.w-2*self.style.border, self.h-2*self.style.border)
    love.graphics.setColor(self.style.textColor)

    -- center horizontally & vertically
    local wB, hB = self:getRawDimensions()
    local xt = self.x+(self.w-wB)/2
    local yt = self.y+(self.h-hB)/2
    love.graphics.setFont(self:getFont())
    love.graphics.print(self.text, xt, yt)
end

Button.__index = Button
setmetatable(Button, {__call = Button.new})

return Button