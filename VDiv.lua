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
    local slots = self:getSlots()
    local xB, yB, wB, hB = self:getContentBox()
    local gap = self.style.gap
    local cellH = (hB+gap) / slots - gap
    local cellW = wB
    local i = 0
    for _, W in ipairs(self.items) do
        W:calculateGeometry(xB, yB+i*(cellH+gap), cellW, cellH*W.style.span)
        i = i + W.style.span
    end
end

return VDiv
