local ContainerBase = require("ContainerBase")

local HDiv = ContainerBase:extend()
HDiv.type = "HDiv"

HDiv.baseStyle = {
    placement = "fill",
}
setmetatable(HDiv.baseStyle, {__index=ContainerBase.baseStyle})

function HDiv:getMinDimensions()
    local maxW = 0
    local maxH = 0
    for _, W in ipairs(self.items) do
        local w, h = W:getMinDimensions()
        maxW = math.max(maxW, w)
        maxH = math.max(maxH, h)
    end
    return maxW * #self.items, maxH
end


function HDiv:calculateGeometry(x, y, w, h)
    ContainerBase.calculateGeometry(self, x, y, w, h)
    local cellW = self.w / #self.items
    local cellH = self.h
    for i, W in ipairs(self.items) do
        W:calculateGeometry(self.x+(i-1)*cellW, self.y, cellW, cellH)
    end
end

return HDiv
