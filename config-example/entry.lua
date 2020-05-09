require("yalg")

local function mEnter(self, x, y)
    self.style.borderColor = rgb(0,0,0)
end

local function mLeave(self, x, y)
    self.style.borderColor = rgb(255,255,255)
end

local function cIncrement(self, x, y, button)
    self.linkedL:setVal(self.linkedL.entry.value + self.linkedL.entry.step)
end

local function cDecrement(self, x, y, button)
    self.linkedL:setVal(self.linkedL.entry.value - self.linkedL.entry.step)
end

local function setVal(self, val)
    local ent = self.entry
    val = math.min(val, ent.max)
    val = math.max(val, ent.min)
    ent.value = val
    if type(ent.format)=="string" then
        self.text = ent.format:format(val)
    else if type(ent.format)=="table" then
            self.text = ent.format[val]
        end
    end
    if ent.callback then
        ent.callback(self, val, self.text)
    end
end

local HDivStyle = {
    gap = 5,
}

local plusButtonStyle = {
    font = Font(20),
    width = 20,
    borderColor = rgb(255, 255, 255),
    backgroundColor = rgb(0,255,0),
    mouseEnter = mEnter,
    mouseLeave = mLeave,
    click = cIncrement,
}

local labelStyle = {

}

local minusButtonStyle = {
    font = Font(20),
    width = 20,
    borderColor = rgb(255, 255, 255),
    backgroundColor = rgb(255,0,0),
    mouseEnter = mEnter,
    mouseLeave = mLeave,
    click = cDecrement,
}

function Entry(name, format, default, min, max, step, callback)
    local l = Label(name, labelStyle, name)
    local plusB = Button("+", plusButtonStyle)
    local minusB = Button("-", minusButtonStyle)

    if type(format)=="table" then
        min = 1
        max = #format
        step = 1
    end

    l.entry = {
        format = format,
        value = default,
        min = min,
        max = max,
        step = step,
    }

    l.setVal = setVal
    l:setVal(default)
    -- do not call callback on initialization
    l.entry.callback = callback


    plusB.linkedL = l
    minusB.linkedL = l

    return HDiv(
        minusB,
        l,
        plusB,
        HDivStyle
    )
end