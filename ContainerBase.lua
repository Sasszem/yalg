local WidgetBase = require("WidgetBase")

local ContainerBase = WidgetBase:extend()

ContainerBase.type = "ContainerBase"

function ContainerBase:new(...)
    local args = {...}
    self.items = {}
    self.style = {}
    setmetatable(self.style, {__index = self.baseStyle})
    local i = 1
    for _, W in ipairs(args) do
        if W.type then
            self.items[i] = W
            i = i + 1
        else
            self.style = W
        end
    end
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
    for i=1, #self.items do
        self.items[i]:draw()
    end
end


return ContainerBase