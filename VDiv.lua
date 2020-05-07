local ContainerBase = require("ContainerBase")

local VDiv = ContainerBase:extend()
VDiv.type="VDiv"


VDiv.baseStyle = {
    placement = "fill",
}
setmetatable(VDiv.baseStyle, {__index=ContainerBase.baseStyle})

function VDiv:getContentDimensions()
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
    local xB, yB, wB, hB = self:getContentBox()
    local gap = self.style.gap
    local cellH = (hB+gap) / #self.items - gap
    local cellW = wB
    for i, W in ipairs(self.items) do
        W:calculateGeometry(xB, yB+(i-1)*(cellH+gap), cellW, cellH)
    end
end

return VDiv
