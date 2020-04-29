local Object = require("Classic")

local WidgetBase = Object:extend()

function WidgetBase:new(style)
    self.style = style or {}
    setmetatable(self.style, {__index = self.baseStyle})
    self.id = self.style.id or getId(self.type)
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

function WidgetBase:setParent(parent)
    self.parent = parent
    self.parent:addWidgetLookup(self.id, self)
end

function WidgetBase:getFont()
    -- fonts are sprecial, and inherit from parent widgets to childer
    return self.style.font or self.parent:getFont()
end

return WidgetBase