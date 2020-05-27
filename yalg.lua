--
-- yalg
-- by Sasszem, 2020
-- compiled from the files of the main repo, from commit 2f0b08cb30c9bdb2797655f2cac8120540285231
--




--
-- Classic.lua
--


--
-- classic
--
-- Copyright (c) 2014, rxi
--
-- This module is free software; you can redistribute it and/or modify it under
-- the terms of the MIT license. See LICENSE for details.
--


local Object = {}
Object.__index = Object


function Object:new()
end


function Object:extend()
  local cls = {}
  for k, v in pairs(self) do
    if k:find("__") == 1 then
      cls[k] = v
    end
  end
  cls.__index = cls
  cls.super = self
  setmetatable(cls, self)
  return cls
end


function Object:implement(...)
  for _, cls in pairs({...}) do
    for k, v in pairs(cls) do
      if self[k] == nil and type(v) == "function" then
        self[k] = v
      end
    end
  end
end


function Object:is(T)
  local mt = getmetatable(self)
  while mt do
    if mt == T then
      return true
    end
    mt = getmetatable(mt)
  end
  return false
end


function Object:__tostring()
  return "Object"
end


function Object:__call(...)
  local obj = setmetatable({}, self)
  obj:new(...)
  return obj
end




--
-- utils.lua
--


function rgb(r, g, b, a)
    local a = a or 255
    return {r/255, g/255, b/255, a/255}
end

local ids = {}
function getId(type)
    ids[type] = (ids[type] or 0) + 1
    return type.."#"..tostring(ids[type])
end

function centerBox(bX, bY, bW, bH, w, h)
    -- center a rect (w, h) inside a box
    local x = bX + (bW-w)/2
    local y = bY + (bH-h)/2
    return x, y
end

local cache = {}

function Font(size, file, hinting)
    hinting = hinting or "normal"
    local fileN = (file or "DEFAULT")..hinting
    if cache[size] then
        if cache[size][fileN] then
            return cache[size][fileN]
        end
    end
    local f
    if file then
        f = love.graphics.newFont(file, size, hinting)
    else
        f = love.graphics.newFont(size, hinting)
    end
    if not cache[size] then
        cache[size] = {}
    end
    cache[size][fileN] = f
    return f
end




--
-- WidgetBase.lua
--


local WidgetBase = Object:extend()
WidgetBase.baseStyle = {
    mouseEnter = function(self, x, y) end,
    mouseLeave = function(self, x, y) end,
    click = function(self, button) end,
    margin = 0,
    border = 0,
    backgroundColor = rgb(0,0,0,0),
    borderColor=rgb(0, 0, 0, 0),
    textColor = rgb(255, 255, 255),
    placement = "fill",
    padding = 0,
    width = 0,
    height = 0,
    span = 1,
}

function WidgetBase:new(style, id)
    style = style or {}
    self.style = {}
    for k, v in pairs(style) do
        self.style[k] = v
    end
    setmetatable(self.style, {__index = self.baseStyle})
    self.id = id or getId(self.type)
    self.mouseOver = false
end

function WidgetBase:calculateGeometry(x, y, w, h)
    x = x + self.style.margin
    y = y + self.style.margin
    w = w - 2*self.style.margin
    h = h - 2*self.style.margin
    if self.style.placement=="center" then
        local wS, hS = self:getMinDimensions()
        -- getMinDimensions() has margin added to it
        wS = wS - 2*self.style.margin
        hS = hS - 2*self.style.margin
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
end

function WidgetBase:getMinDimensions()
    local w, h = self:getContentDimensions()
    w = math.max(self.style.width, w)
    h = math.max(self.style.height, h)
    local d = 2*self.style.border + 2*self.style.margin + 2*self.style.padding
    return w+d, h+d
end

function WidgetBase:getContentBox()
    local d = self.style.border + self.style.padding
    local x = self.x + d
    local y = self.y + d
    local w = self.w - 2*d
    local h = self.h - 2*d
    return x, y, w, h
end

function WidgetBase:inside(x, y)
    local insideX = (x >= self.x) and (x <= self.x + self.w)
    local insideY = (y >= self.y) and (y <= self.y + self.h)
    return insideX and insideY
end

function WidgetBase:handleMouse(x, y)
    local inside = self:inside(x, y)
    if inside and not self.mouseOver then
        self.mouseOver = true
        if self.style.mouseEnter then
            self.style.mouseEnter(self, x, y)
        end
    end
    if not inside and self.mouseOver then
        self.mouseOver = false
        if self.style.mouseLeave then
            self.style.mouseLeave(self, x, y)
        end
    end
end

function WidgetBase:handleClick(x, y, button)
    if not self:inside(x, y) then
        return
    end
    if self.style.click then
        self.style.click(self, x, y, button)
    end
end

function WidgetBase:setParent(parent)
    self.parent = parent
    self.parent:addWidgetLookup(self.id, self)
end

function WidgetBase:getFont()
    -- fonts are sprecial, and inherit from parent widgets to childer
    return self.style.font or self.parent:getFont()
end

function WidgetBase:draw()
    -- draw background
    love.graphics.setColor(self.style.backgroundColor)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)

    -- draw border
    love.graphics.setColor(self.style.borderColor)
    love.graphics.setLineWidth(self.style.border)
    local b = self.style.border / 2
    love.graphics.rectangle("line", self.x + b, self.y + b, self.w - 2*b, self.h - 2*b)
end

function WidgetBase:getWidget(id)
    return self.parent:getWidget(id)
end




--
-- ContainerBase.lua
--


local ContainerBase = WidgetBase:extend()
ContainerBase.baseStyle = {
    gap = 0,
    slots = 0,
}
setmetatable(ContainerBase.baseStyle, {__index=WidgetBase.baseStyle})
ContainerBase.type = "ContainerBase"

function ContainerBase:new(...)
    local args = {...}
    self.items = {}
    self.widgets = {}
    local style = {}
    local id = nil
    local i = 1
    for _, W in ipairs(args) do
        if type(W)=="string" then
            id = W
        else
            if W.type then
                self.items[i] = W
                i = i + 1
            else
                style = W
            end
        end
    end
    WidgetBase.new(self, style, id)
    for _, W in ipairs(self.items) do
        W:setParent(self)
    end
    self:addWidgetLookup(self.id, self)
end

function ContainerBase:addWidgetLookup(key, widget)
    assert(not self.widgets[key], "ID duplication in container \""..self.id.."\": "..key)
    self.widgets[key] = widget
end

function ContainerBase:getWidget(id)
    if self.widgets then
        return assert(self.widgets[id], "Widget ID not found in "..self.id..": "..id)
    end
    return self.parent:getWidget(id)
end

function ContainerBase:setParent(parent)
    self.parent = parent
    for k, v in pairs(self.widgets) do
        parent:addWidgetLookup(k, v)
    end
    self.widgets = nil
end

function ContainerBase:draw()
    WidgetBase.draw(self)
    for i=1, #self.items do
        self.items[i]:draw()
    end
end

function ContainerBase:handleMouse(x, y)
    WidgetBase.handleMouse(self, x, y)
    for _, W in ipairs(self.items) do
        W:handleMouse(x, y)
    end
end

function ContainerBase:handleClick(x, y, button)
    if not self:inside(x, y) then
        return
    end
    WidgetBase.handleClick(self, x, y, button)
    for _, W in ipairs(self.items) do
        W:handleClick(x, y, button)
    end
end

function ContainerBase:getSlots()
    local slots = 0
    for _, W in ipairs(self.items) do
        slots = slots + W.style.span
    end
    return math.max(slots, self.style.slots)
end




--
-- VDiv.lua
--


VDiv = ContainerBase:extend()
VDiv.type="VDiv"


VDiv.baseStyle = {
    placement = "fill",
}
setmetatable(VDiv.baseStyle, {__index=ContainerBase.baseStyle})

function VDiv:getContentDimensions()
    local maxW = 0
    local maxH = 0
    for _, W in ipairs(self.items) do
        local w, h = W:getMinDimensions()
        maxW = math.max(maxW, w)
        maxH = math.max(maxH, h)
    end
    return maxW, maxH * #self.items + self.style.gap * (#self.items - 1)
end

function VDiv:calculateGeometry(x, y, w, h)
    ContainerBase.calculateGeometry(self, x, y, w, h)
    local slots = self:getSlots()
    local xB, yB, wB, hB = self:getContentBox()
    local gap = self.style.gap
    local cellH = (hB+gap) / slots - gap
    local cellW = wB
    local i = 0
    for _, W in ipairs(self.items) do
        W:calculateGeometry(xB, yB+i*(cellH+gap), cellW, cellH*W.style.span)
        i = i + W.style.span
    end
end





--
-- HDiv.lua
--


HDiv = ContainerBase:extend()
HDiv.type = "HDiv"

HDiv.baseStyle = {
    placement = "fill",
}
setmetatable(HDiv.baseStyle, {__index=ContainerBase.baseStyle})

function HDiv:getContentDimensions()
    local maxW = 0
    local maxH = 0
    for _, W in ipairs(self.items) do
        local w, h = W:getMinDimensions()
        maxW = math.max(maxW, w)
        maxH = math.max(maxH, h)
    end
    return maxW * #self.items + self.style.gap*(#self.items - 1), maxH
end


function HDiv:calculateGeometry(x, y, w, h)
    ContainerBase.calculateGeometry(self, x, y, w, h)
    local slots = self:getSlots()
    local gap = self.style.gap
    local xB, yB, wB, hB = self:getContentBox()
    local cellW = (wB+gap) / slots - gap
    local cellH = hB
    local i = 0
    for _, W in ipairs(self.items) do
        W:calculateGeometry(xB+i*(cellW + gap), yB, cellW*W.style.span, cellH)
        i = i + W.style.span
    end
end




--
-- Switcher.lua
--


Switcher = ContainerBase:extend()
Switcher.baseStyle = {
    gap = 0,
}
setmetatable(Switcher.baseStyle, {__index=ContainerBase.baseStyle})
Switcher.type = "Switcher"

function Switcher:new(...)
    self.switcherWidgets = {}
    self.selected = nil
    ContainerBase.new(self, ...)
    for _, W in ipairs(self.items) do
        self.switcherWidgets[W.id] = W
        self.selected = W.id
    end
end

function Switcher:getContentDimensions()
    local maxW = 0
    local maxH = 0
    for _, W in ipairs(self.items) do
        local w, h = W:getMinDimensions()
        maxW = math.max(maxW, w)
        maxH = math.max(maxH, h)
    end
    return maxW, maxH
end

function Switcher:calculateGeometry(x, y, w, h)
    ContainerBase.calculateGeometry(self, x, y, w, h)
    local xB, yB, wB, hB = self:getContentBox()
    for _, W in ipairs(self.items) do
        W:calculateGeometry(xB, yB, wB, hB)
    end
end


function Switcher:draw()
    WidgetBase.draw(self)
    self.switcherWidgets[self.selected]:draw()
end

function Switcher:handleMouse(x, y)
    WidgetBase.handleMouse(self, x, y)
    self.switcherWidgets[self.selected]:handleMouse(x, y)
end

function Switcher:handleClick(x, y, button)
    if not self:inside(x, y) then
        return
    end
    WidgetBase.handleClick(self, x, y, button)
    self.switcherWidgets[self.selected]:handleClick(x, y, button)
end




--
-- GUI.lua
--


GUI = VDiv:extend()
GUI.type = "GUI"

function GUI:new(...)
    VDiv.new(self, ...)
    local w, h = love.graphics.getDimensions()
    self.w = w
    self.h = h
    self:calculateGeometry(0, 0, w, h)
end

function GUI:recalculate()
    self:calculateGeometry(0, 0, self.w, self.h)
end

function GUI:getFont()
    -- fonts are sprecial, and inherit from parent widgets to childer
    return self.style.font or Font(30)
end

function GUI:update()
    local x, y = love.mouse.getPosition()
    self:handleMouse(x, y)
end

function GUI:resize(w, h)
    self.w = w
    self.h = h
    self:calculateGeometry(0, 0, w, h)
end




--
-- Label.lua
--


Label = WidgetBase:extend()
Label.type = "Label"

Label.baseStyle = {
}
setmetatable(Label.baseStyle, {__index=WidgetBase.baseStyle})

function Label:new(text, style, id)
    self.text = text
    WidgetBase.new(self, style, id)
end

function Label:getContentDimensions()
    local font = self:getFont()
    local w = font:getWidth(self.text)
    local lines = 1
    self.text:gsub("\n", function(...) lines = lines + 1 end)
    local h = font:getHeight() * lines
    return w, h
end

function Label:draw()
    WidgetBase.draw(self)
    -- center text horizontally & vertically
    local bX, bY, bW, bH = self:getContentBox()
    local w, h = self:getContentDimensions()
    local x, y = centerBox(bX, bY, bW, bH, w, h)

    -- draw text
    love.graphics.setFont(self:getFont())
    love.graphics.setColor(self.style.textColor)
    love.graphics.print(self.text, x, y)
end




--
-- Button.lua
--


Button = Label:extend()
Button.type = "Button"

Button.baseStyle = {
    border=3,
    borderColor=rgb(255, 0, 0),
    backgroundColor=rgb(100, 100, 100),
    placement = "center",
    margin = 0,
    padding = 5,
}

setmetatable(Button.baseStyle, {__index=Label.baseStyle})