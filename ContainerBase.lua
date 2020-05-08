local WidgetBase = require("WidgetBase")

local ContainerBase = WidgetBase:extend()
ContainerBase.baseStyle = {
    gap = 0,
    slots = 0,
}
setmetatable(ContainerBase.baseStyle, {__index=WidgetBase.baseStyle})
ContainerBase.type = "ContainerBase"

function ContainerBase:new(...)
    local args = {...}
    self.items = {}
    local style = {}
    local i = 1
    for _, W in ipairs(args) do
        if W.type then
            self.items[i] = W
            i = i + 1
        else
            style = W
        end
    end
    WidgetBase.new(self, style)
end

function ContainerBase:addWidgetLookup(key, widget)
    self.parent:addWidgetLookup(key, widget)
end

function ContainerBase:setParent(parent)
    WidgetBase.setParent(self, parent)
    -- set parent for every child node
    for _, W in ipairs(self.items) do
        W:setParent(self)
    end
end

function ContainerBase:draw()
    WidgetBase.draw(self)
    for i=1, #self.items do
        self.items[i]:draw()
    end
end

function ContainerBase:handleMouse(x, y)
    WidgetBase.handleMouse(self, x, y)
    for _, W in ipairs(self.items) do
        W:handleMouse(x, y)
    end
end

function ContainerBase:handleClick(x, y, button)
    if not self:inside(x, y) then
        return
    end
    WidgetBase.handleClick(self, x, y, button)
    for _, W in ipairs(self.items) do
        W:handleClick(x, y, button)
    end
end

function ContainerBase:getSlots()
    local slots = 0
    for _, W in ipairs(self.items) do
        slots = slots + W.style.span
    end
    return math.max(slots, self.style.slots)
end

return ContainerBase