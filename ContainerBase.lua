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
    self.widgets = {}
    local style = {}
    local id = nil
    local i = 1
    for _, W in ipairs(args) do
        if type(W)=="string" then
            id = W
        else
            if W.type then
                self.items[i] = W
                i = i + 1
            else
                style = W
            end
        end
    end
    WidgetBase.new(self, style, id)
    for _, W in ipairs(self.items) do
        W:setParent(self)
    end
    self:addWidgetLookup(self.id, self)
end

function ContainerBase:addWidgetLookup(key, widget)
    assert(not self.widgets[key], "ID duplication in container \""..self.id.."\": "..key)
    self.widgets[key] = widget
end

function ContainerBase:getWidget(id)
    if self.widgets then
        return assert(self.widgets[id], "Widget ID not found in "..self.id..": "..id)
    end
    return self.parent:getWidget(id)
end

function ContainerBase:setParent(parent)
    self.parent = parent
    for k, v in pairs(self.widgets) do
        parent:addWidgetLookup(k, v)
    end
    self.widgets = nil
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