local WidgetBase = require("WidgetBase")

local ContainerBase = WidgetBase:extend()
ContainerBase.baseStyle = {
    gap = 0,
}
setmetatable(ContainerBase.baseStyle, {__index=WidgetBase.baseStyle})
ContainerBase.type = "ContainerBase"

function ContainerBase:new(...)
    local args = {...}
    self.items = {}
    self.style = {}
    local i = 1
    for _, W in ipairs(args) do
        if W.type then
            self.items[i] = W
            i = i + 1
        else
            self.style = W
        end
    end
    setmetatable(self.style, {__index = self.baseStyle})
    self.id = self.style.id or getId(self.type)
end

function ContainerBase:addWidgetLookup(key, widget)
    self.parent:addWidgetLookup(key, widget)
end

function ContainerBase:setParent(parent)
    self.parent = parent
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


return ContainerBase