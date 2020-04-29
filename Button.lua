require("utils")

local Label = require("Label")
local Button = Label:extend()
Button.type = "Button"

Button.baseStyle = {
    border=3,
    borderColor=rgb(255, 0, 0),
    backgroundColor=rgb(100, 100, 100),
    textColor=rgb(255, 255, 255),
    placement = "fill",
    margin = 0,
}

return Button