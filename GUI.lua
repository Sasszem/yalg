local VDiv = require("VDiv")
local GUI = VDiv:extend()

function GUI:new(...)
    VDiv.new(self, ...)
    self.id = "GUI"
    self.widgets = {}
    local w, h = love.graphics.getDimensions()
    self.w = w
    self.h = h
    self:setParent(self)
    self:calculateGeometry(0, 0, w, h)
end

function GUI:recalculate()
    self:calculateGeometry(0, 0, self.w, self.h)
end

function GUI:addWidgetLookup(key, widget)
    self.widgets[key] = widget
end

function GUI:getWidget(id)
    return self.widgets[id]
end

function GUI:getFont()
    -- fonts are sprecial, and inherit from parent widgets to childer
    return self.style.font or Font(30)
end

function GUI:update()
    local x, y = love.mouse.getPosition()
    self:handleMouse(x, y)
end

function GUI:resize(w, h)
    self.w = w
    self.h = h
    self:calculateGeometry(0, 0, w, h)
end

return GUI