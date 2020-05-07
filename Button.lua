require("utils")

local Label = require("Label")
local Button = Label:extend()
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
return Button