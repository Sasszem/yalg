local U = require("utils")

local YALG = {
    GUI = require("GUI"),
    VDiv = require("VDiv"),
    HDiv = require("HDiv"),
    Button = require("Button"),
    Label = require("Label"),
    Switcher = require("Switcher"),
    Font = U.Font,
    rgb = U.rgb,
}

function YALG.import()
    for k, v in pairs(YALG) do
        if k ~= "import" then
            _G[k] = v
        end
    end
end

return YALG
