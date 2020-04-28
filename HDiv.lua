local HDiv = {
    type="HDiv"
}

HDiv.baseStyle = {
    placement = "fill",
}

HDiv.__index = HDiv

function HDiv:new(...)
    local args = {...}
    local o = {}
    setmetatable(o, HDiv)
    o.items = {}
    o.style = {}
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

function HDiv:setParent(parent)
    self.parent = parent
    -- set parent for every child node
    for _, W in ipairs(self.items) do
        W:setParent(self)
    end
end

function HDiv:calculateStyle()
    self.cStyle = mergeTables(self.style, self.parent.style, self.baseStyle)
    for _, W in ipairs(self.items) do
        W:calculateStyle()
    end
end

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
    local cellW = self.w / #self.items
    local cellH = self.h
    for i, W in ipairs(self.items) do
        W:calculateGeometry(self.x+(i-1)*cellW, self.y, cellW, cellH)
    end
end


function HDiv:draw()
    -- divide horisontally & issue drawing
    for i=1, #self.items do
        self.items[i]:draw()
    end
end


setmetatable(HDiv, {__call = HDiv.new})
return HDiv
