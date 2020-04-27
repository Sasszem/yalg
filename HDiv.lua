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
    -- copy the styles into self styles
    for k, v in pairs(parent.style) do
        self.style[k] = self.style[k] or v
    end

    -- copy base style into self
    for k, v in pairs(self.baseStyle) do
        self.style[k] = self.style[k] or v
    end

    -- set parent for every child node
    for _, W in ipairs(self.items) do
        W:setParent(self)
    end
end

function HDiv:draw(x, y, w, h)
    -- divide horisontally & issue drawing
    local cellWidth = w / #self.items
    for i=1, #self.items do
        self.items[i]:draw(x+(i-1)*cellWidth, y, cellWidth, h)
    end
end


HDiv.__call = HDiv.new
setmetatable(HDiv, HDiv)
return HDiv
