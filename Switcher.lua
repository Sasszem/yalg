local ContainerBase = require("ContainerBase")
local WidgetBase = require("WidgetBase")
local Switcher = ContainerBase:extend()
Switcher.baseStyle = {
    gap = 0,
}
setmetatable(Switcher.baseStyle, {__index=ContainerBase.baseStyle})
Switcher.type = "Switcher"

function Switcher:new(...)
    self.switcherWidgets = {}
    self.selected = nil
    ContainerBase.new(self, ...)
    for _, W in ipairs(self.items) do
        self.switcherWidgets[W.id] = W
        self.selected = W.id
    end
end

function Switcher:getContentDimensions()
    local maxW = 0
    local maxH = 0
    for _, W in ipairs(self.items) do
        local w, h = W:getMinDimensions()
        maxW = math.max(maxW, w)
        maxH = math.max(maxH, h)
    end
    return maxW, maxH
end

function Switcher:calculateGeometry(x, y, w, h)
    ContainerBase.calculateGeometry(self, x, y, w, h)
    local xB, yB, wB, hB = self:getContentBox()
    for _, W in ipairs(self.items) do
        W:calculateGeometry(xB, yB, wB, hB)
    end
end


function Switcher:draw()
    WidgetBase.draw(self)
    self.switcherWidgets[self.selected]:draw()
end

function Switcher:handleMouse(x, y)
    WidgetBase.handleMouse(self, x, y)
    self.switcherWidgets[self.selected]:handleMouse(x, y)
end

function Switcher:handleClick(x, y, button)
    if not self:inside(x, y) then
        return
    end
    WidgetBase.handleClick(self, x, y, button)
    self.switcherWidgets[self.selected]:handleClick(x, y, button)
end

return Switcher