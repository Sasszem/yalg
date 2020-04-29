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
    return maxW, maxH * #self.items
end

function VDiv:calculateGeometry(x, y, w, h)
    if self.style.placement=="center" then
        local wS, hS = self:getMinDimensions()
        self.x = x + (w-wS)/2
        self.y = y + (h-hS)/2
        self.w = wS
        self.h = hS
    else
        self.x = x
        self.y = y
        self.w = w
        self.h = h
    end
    local cellW = self.w
    local cellH = self.h / #self.items
    for i, W in ipairs(self.items) do
        W:calculateGeometry(self.x, self.y+(i-1)*cellH, cellW, cellH)
    end
end

return VDiv
