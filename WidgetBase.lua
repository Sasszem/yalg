local Object = require("Classic")

local WidgetBase = Object:extend()
WidgetBase.baseStyle = {
    mouseEnter = function(self, x, y) end,
    mouseLeave = function(self, x, y) end,
    click = function(self, button) end,
    margin = 0,
    border = 0,
    backgroundColor = rgb(0,0,0,0),
    borderColor=rgb(0, 0, 0, 0),
    textColor = rgb(255, 255, 255),
    placement = "fill",
    padding = 0,
    width = 0,
    height = 0,
}

function WidgetBase:new(style)
    self.style = style or {}
    setmetatable(self.style, {__index = self.baseStyle})
    self.id = self.style.id or getId(self.type)
    self.mouseOver = false
end

function WidgetBase:calculateGeometry(x, y, w, h)
    x = x + self.style.margin
    y = y + self.style.margin
    w = w - 2*self.style.margin
    h = h - 2*self.style.margin
    if self.style.placement=="center" then
        local wS, hS = self:getMinDimensions()
        -- getMinDimensions() has margin added to it
        wS = wS - 2*self.style.margin
        hS = hS - 2*self.style.margin
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

function WidgetBase:getMinDimensions()
    local w, h = self:getContentDimensions()
    w = math.max(self.style.width, w)
    h = math.max(self.style.height, h)
    local d = 2*self.style.border + 2*self.style.margin + 2*self.style.padding
    return w+d, h+d
end

function WidgetBase:getContentBox()
    local d = self.style.border + self.style.padding
    local x = self.x + d
    local y = self.y + d
    local w = self.w - 2*d
    local h = self.h - 2*d
    return x, y, w, h
end

function WidgetBase:inside(x, y)
    local insideX = (x >= self.x) and (x <= self.x + self.w)
    local insideY = (y >= self.y) and (y <= self.y + self.h)
    return insideX and insideY
end

function WidgetBase:handleMouse(x, y)
    local inside = self:inside(x, y)
    if inside and not self.mouseOver then
        self.mouseOver = true
        if self.style.mouseEnter then
            self.style.mouseEnter(self, x, y)
        end
    end
    if not inside and self.mouseOver then
        self.mouseOver = false
        if self.style.mouseLeave then
            self.style.mouseLeave(self, x, y)
        end
    end
end

function WidgetBase:handleClick(x, y, button)
    if not self:inside(x, y) then
        return
    end
    if self.style.click then
        self.style.click(self, x, y, button)
    end
end

function WidgetBase:setParent(parent)
    self.parent = parent
    self.parent:addWidgetLookup(self.id, self)
end

function WidgetBase:getFont()
    -- fonts are sprecial, and inherit from parent widgets to childer
    return self.style.font or self.parent:getFont()
end

function WidgetBase:draw()
    -- draw background
    love.graphics.setColor(self.style.backgroundColor)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)

    -- draw border
    love.graphics.setColor(self.style.borderColor)
    love.graphics.setLineWidth(self.style.border)
    local b = self.style.border / 2
    love.graphics.rectangle("line", self.x + b, self.y + b, self.w - 2*b, self.h - 2*b)
end

return WidgetBase