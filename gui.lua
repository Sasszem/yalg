Button = require("Button")
Label = require("Label")
HDiv = require("HDiv")
VDiv = require("VDiv")
Font = require("Font")

GUI = {}
GUI.__index = GUI

function GUI:new(...)
    local args = {...}
    local o = {}
    local w, h = love.graphics.getDimensions()
    o.w = w
    o.h = h
    o.cStyle = {}
    o.d = VDiv(unpack(args))
    o.d:setParent(o)
    o.d:calculateStyle()
    setmetatable(o, GUI)
    return o
end

function GUI:draw()
    self.d:draw(0, 0, self.w, self.h)
end

setmetatable(GUI, {__call = GUI.new})
