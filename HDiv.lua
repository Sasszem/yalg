local HDiv = {
    type="HDiv"
}

HDiv.baseStyle = {

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

function HDiv:draw(x, y, w, h)
    -- divide horisontally & issue drawing
    local cellWidth = w / #self.items
    for i=1, #self.items do
        self.items[i]:draw(x+(i-1)*cellWidth, y, cellWidth, h)
    end
end


setmetatable(HDiv, {__call = HDiv.new})
return HDiv
