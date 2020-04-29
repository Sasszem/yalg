local Object = require("Classic")

local WidgetBase = Object:extend()
WidgetBase.baseStyle = {
    mouseEnter = function(self, x, y) end,
    mouseLeave = function(self, x, y) end,
    click = function(self, button) end,
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

return WidgetBase