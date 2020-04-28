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
    setmetatable(o.style, {__index = o.baseStyle})
    local i = 1
    for _, W in ipairs(args) do
        if W.type then
            o.items[i] = W
            i = i + 1
        else
            o.style = W
        end
    end
    o.id = o.style.id or getId(o.type)
    return o
end

function HDiv:setParent(parent)
    self.parent = parent
    -- set parent for every child node
    for _, W in ipairs(self.items) do
        W:setParent(self)
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

function HDiv:addWidgetLookup(key, widget)
    self.parent:addWidgetLookup(key, widget)
end

function HDiv:calculateGeometry(x, y, w, h)
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
    local cellW = self.w / #self.items
    local cellH = self.h
    for i, W in ipairs(self.items) do
        W:calculateGeometry(self.x+(i-1)*cellW, self.y, cellW, cellH)
    end
end

function HDiv:getFont()
    -- fonts are sprecial, and inherit from parent widgets to childer
    return self.style.font or self.parent:getFont()
end

function HDiv:draw()
    -- divide horisontally & issue drawing
    for i=1, #self.items do
        self.items[i]:draw()
    end
end


setmetatable(HDiv, {__call = HDiv.new})
return HDiv
