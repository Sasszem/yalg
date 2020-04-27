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

function VDiv:draw(x, y, w, h)
    -- divide vertically & issue drawing
    --print("Vdiv draw, "..tostring(#self.items))
    local cellHeight = h / #self.items
    for i=1, #self.items do
        self.items[i]:draw(x, y+(i-1)*cellHeight, w, cellHeight)
    end
end

setmetatable(VDiv, {__call = VDiv.new})

return VDiv
