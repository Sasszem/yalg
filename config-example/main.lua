require("yalg").import()
require("entry")

local buttonToSwitcherMap = {
    Video = "videoSettings",
    Audio = "audioSettings",
    Gameplay = "gameSettings",
    Misc = "miscSettings"
}


local chooserButtonStyle = {
    placement="fill",
    mouseEnter = function(self, x, y)
        self.style.borderColor = rgb(0,255,00)
    end,
    mouseLeave = function (self, x, y)
        self.style.borderColor = rgb(255,0,00)
    end,
    click = function (self, x, y, button)
        g.widgets.switcher.selected = buttonToSwitcherMap[self.text]
    end
}

local settingsStyle = {
    gap = 5,
    slots = 12,
    font = Font(20),
}

local rowStyle = {
    slots = 3,
    border = 3,
    borderColor = rgb(255,255,255),
    placement = "fill"
}

local function setGraphicsMode(self, val, text)
    local l = {{256, 128}, {800, 600}, {1024, 768}}
    local m = self:getWidget("resolution").entry.value
    local f = self:getWidget("fullscreen").entry.value
    love.window.setMode(l[m][1], l[m][2], {resizable=true, minwidth=100, minheight=100})
    print("Resolution: "..tostring(l[m][1]).."x"..tostring(l[m][2]))
    love.window.setFullscreen(f==2)
    self:getWidget("GUI#1"):resize(l[m][1], l[m][2])
end

local VideoSettings = VDiv(
    HDiv(
        Label("Resolution"),
        HDiv(
            Entry("resolution", {"256x128", "600x800", "1024x768"}, 2,0,0,0, setGraphicsMode), {span = 2}),
        rowStyle
    ),
    HDiv(
        Label("Fullscreen mode"),
        HDiv(Entry("fullscreen", {"off", "on"}, 1,0,0,0, setGraphicsMode), {span = 2}),
        rowStyle
    ),
    settingsStyle,
    "videoSettings"
)

local audioSettings = VDiv(
    HDiv(
        Label("Master volume"),
        HDiv(Entry("volumeMaster", "%d %%", 100,10,100,5), {span = 2}),
        rowStyle
    ),
    HDiv(
        Label("Music volume"),
        HDiv(Entry("volumeMusic", "%d %%", 100,10,100,5), {span = 2}),
        rowStyle
    ),
    HDiv(
        Label("Effects volume"),
        HDiv(Entry("volumeEffects", "%d %%", 100,10,100,5), {span = 2}),
        rowStyle
    ),
    settingsStyle,
    "audioSettings"
)

local gameSettings = VDiv(
    HDiv(
        Label("Cheats"),
        HDiv(Entry("cheats", {"off", "on"}, 1,0,0,0), {span = 2}),
        rowStyle
    ),
    HDiv(
        Label("Difficulty"),
        HDiv(Entry("difficulty", {"easy", "normal", "hard", "Deus Ex"}, 2,0,0,0), {span = 2}),
        rowStyle
    ),
    HDiv(
        Label("Debug mode"),
        HDiv(Entry("debug", {"off", "on"}, 1,0,0,0), {span = 2}),
        rowStyle
    ),
    settingsStyle,
    "gameSettings"
)

local miscSettings = VDiv(
    HDiv(
        Label("Misc 1"),
        HDiv(Entry("misc1", {"dummy", "values", "here"}, 1,0,0,0), {span = 2}),
        rowStyle
    ),
    HDiv(
        Label("Misc 2"),
        HDiv(Entry("misc2", {"here", "too"}, 1,0,0,0), {span = 2}),
        rowStyle
    ),
    HDiv(
        Label("Misc 3"),
        HDiv(Entry("misc3", {"what", "to", "write", "here", "?"}, 1,0,0,0), {span = 2}),
        rowStyle
    ),
    settingsStyle,
    "miscSettings"
)


g = GUI(
    HDiv(
        VDiv(
            Button("Video", chooserButtonStyle),
            Button("Audio", chooserButtonStyle),
            Button("Gameplay", chooserButtonStyle),
            Button("Misc", chooserButtonStyle),
            {
                gap = 5,
                slots = 12,
            },
            "sidebar"
        ),
        Switcher(
            VideoSettings,
            audioSettings,
            gameSettings,
            miscSettings,
            {
                span=3,
                backgroundColor=rgb(0,0,255)
            },
            "switcher"
        ),
        {
            gap = 5,
        }
    )
)

function love.load()
    love.window.setMode( 800, 600, {resizable=true, minwidth=100, minheight=100})
end

function love.draw()
    --love.graphics.translate(400, 300)
    --love.graphics.scale(10, 10)
    --love.graphics.translate(-400, -300)
    g:draw()
end

function love.resize(w, h)
    g:resize(w, h)
end

function love.update(dt)
    g:update()
end

function love.mousepressed( x, y, button, istouch, presses )
    g:handleClick(x, y, button)
end