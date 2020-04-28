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
    setmetatable(o, GUI)
    local w, h = love.graphics.getDimensions()
    o.w = w
    o.h = h
    o.widgets = {}
    o.style = {font = Font(20)}
    o.d = VDiv(unpack(args))
    o.d:setParent(o)
    o.d:calculateGeometry(0, 0, o.w, o.h)
    return o
end

function GUI:draw()
    self.d:draw()
end

function GUI:recalculate()
    self.d:calculateGeometry(0, 0, self.w, self.h)
end

function GUI:addWidgetLookup(key, widget)
    self.widgets[key] = widget
end

function GUI:getFont()
    -- fonts are sprecial, and inherit from parent widgets to childer
    return self.style.font or Font(30)
end

function GUI:resize(w, h)
    self.w = w
    self.h = h
    self.d:calculateGeometry(0, 0, w, h)
end

setmetatable(GUI, {__call = GUI.new})
