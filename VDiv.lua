local VDiv = {
    type="VDiv"
}
VDiv.__index = VDiv

VDiv.baseStyle = {

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

function VDiv:draw(x, y, w, h)
    -- divide vertically & issue drawing
    --print("Vdiv draw, "..tostring(#self.items))
    local cellHeight = h / #self.items
    for i=1, #self.items do
        self.items[i]:draw(x, y+(i-1)*cellHeight, w, cellHeight)
    end
end

VDiv.__call = VDiv.new
setmetatable(VDiv, VDiv)

return VDiv
