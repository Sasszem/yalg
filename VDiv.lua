local VDiv = {
    type="VDiv"
}
VDiv.__index = VDiv

VDiv.baseStyle = {
    placement = "fill",
}

function VDiv:new(...)
    local args = {...}
    local o = {}
    setmetatable(o, VDiv)
    o.items = {}
    local i = 1
    for _, W in ipairs(args) do
        if W.type then
            o.items[i] = W
            i = i + 1
        else
            o.style = W
        end
    end

    return o
end

function VDiv:setParent(parent)
    self.parent = parent
    -- set parent for every child node
    for _, W in ipairs(self.items) do
        W:setParent(self)
    end
end

function VDiv:calculateStyle()
    self.cStyle = mergeTables(self.style, self.parent.style, self.baseStyle)
    for _, W in ipairs(self.items) do
        W:calculateStyle()
    end
end

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
    if self.cStyle.placement=="center" then
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


function VDiv:draw()
    for i=1, #self.items do
        self.items[i]:draw()
    end
end

setmetatable(VDiv, {__call = VDiv.new})

return VDiv
