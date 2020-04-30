local ContainerBase = require("ContainerBase")

local VDiv = ContainerBase:extend()
VDiv.type="VDiv"


VDiv.baseStyle = {
    placement = "fill",
}
setmetatable(VDiv.baseStyle, {__index=ContainerBase.baseStyle})

function VDiv:getMinDimensions()
    local maxW = 0
    local maxH = 0
    for _, W in ipairs(self.items) do
        local w, h = W:getMinDimensions()
        maxW = math.max(maxW, w)
        maxH = math.max(maxH, h)
    end
    return maxW, maxH * #self.items + self.style.gap * (#self.items - 1)
end

function VDiv:calculateGeometry(x, y, w, h)
    ContainerBase.calculateGeometry(self, x, y, w, h)
    local gap = self.style.gap
    local cellH = (self.h+gap) / #self.items - gap
    local cellW = self.w
    for i, W in ipairs(self.items) do
        W:calculateGeometry(self.x, self.y+(i-1)*(cellH+gap), cellW, cellH)
    end
end

return VDiv
