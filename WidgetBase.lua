local Object = require("Classic")

local WidgetBase = Object:extend()

function WidgetBase:new(style)
    self.style = style or {}
    setmetatable(self.style, {__index = self.baseStyle})
    self.id = self.style.id or getId(self.type)
    print("Created new "..self.type.." with ID "..self.id)
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