local Y = require("yalg")

local g = {}

g[1] = Y.GUI(
    Y.HDiv(
        Y.Label("A label"),
        Y.Button("Click me!", {
            Font=Y.Font(40),
            textColor=Y.rgb(255, 0, 0),
        }, "btnClickMe")
    ),
    Y.HDiv(
        Y.Label("Another label"),
        Y.Button("Do NOT click me!",{
            placement="fill",
            textColor=Y.rgb(0,0,255),
            border=9,
            borderColor=Y.rgb(0,255,0),
            backgroundColor=Y.rgb(50,50,50),
        }, "noClickMe"),
        {
            Font=Y.Font(40),
        }
    ),
    {
        Font=Y.Font(20),
    }
)

local a = g[1]
-- use this because we do that GUI switching

function a.widgets.noClickMe.style:click(x, y, button)
    self.text = "F U"
end

function a.widgets.noClickMe.style:mouseLeave(x, y)
    if self.text~="F U" then
        self.text = "Do NOT click me!"
    end
end

function a.widgets.noClickMe.style:mouseEnter(x, y)
    if self.text~="F U" then
        self.text = "DO NOT EVEN TRY!"
    end
end

g[2] = Y.GUI(
    Y.Button("New Game", {placement="fill"}),
    Y.Button("Highscores", {placement="fill"}),
    Y.Button("Quit", {placement="fill"}),
    {
        Font=Y.Font(30),
        placement="center",
        gap = 10,
    }
)

g[3] = Y.GUI(
    Y.Button("New Game", {padding=30, placement="fill"}),
    Y.Button("Highscores", {padding=0, placement="fill"}),
    Y.Button("Quit", {placement="fill"}),
    {
        Font=Y.Font(30),
        backgroundColor = Y.rgb(0, 255, 0),
        gap=20,
    }
)

g[4] = Y.GUI(
    Y.HDiv(
        Y.Label("", {
            backgroundColor = Y.rgb(255, 0, 0),
        }),
        Y.Label("", {
            backgroundColor = Y.rgb(0, 255, 0),
        })
    ),
    Y.HDiv(
        Y.Label("", {
            backgroundColor = Y.rgb(0, 0, 255),
            click = function (self, x, y, button)
                self.style.backgroundColor[1] = 1 - self.style.backgroundColor[1]
            end
        }),
        Y.Label("", {
            backgroundColor = Y.rgb(255, 255, 255),
        })
    )
)

g[5] = Y.GUI(
    Y.HDiv(
        Y.Label("I'm just a label!"),
        Y.Button("And I'm a button"),
        {
            margin = 20,
            border = 4,
            borderColor = Y.rgb(0, 255, 0),
        }
    ),
    Y.HDiv(
        Y.Label("Lonely label here...")
    ),
    {
        border = 3,
        borderColor = Y.rgb(0,0,255)
    }
)

g[#g + 1] = Y.GUI(
    Y.HDiv(
        Y.Button("Left button", {placement="fill", margin=1}),
        Y.Button("Right button", {placement="center"}),
        {
            placement="center",
            border=5,
            backgroundColor = Y.rgb(255, 255, 255),
            borderColor=Y.rgb(0,0,255),
        }
    )
)

g[#g + 1] = Y.GUI(
    Y.HDiv(
        Y.Label("", {width=100, height=100, backgroundColor=Y.rgb(255, 0, 0), placement="center"})
    )
)

g[#g + 1] = Y.GUI(
    Y.Label("A multiline\nlabel is this", {border=3, borderColor=Y.rgb(255,255,255), placement="center"})
)

function love.load()
    love.window.setMode( 800, 600, {resizable=true, minwidth=100, minheight=100})
end

local sel = 1

local t = 0

function love.draw()
    --love.graphics.translate(400, 300)
    --love.graphics.scale(10, 10)
    --love.graphics.translate(-400, -300)
    g[sel]:draw()
end

function love.keypressed(key, scancode, isrepeat)
    if key=="space" and not isrepeat then
        sel = sel + 1
        if sel>#g then
            sel = sel - #g
        end
    end
end

function love.resize(w, h)
    for i=1, #g do
        g[i]:resize(w, h)
    end
end

function love.update(dt)
    g[sel]:update()
    t = t + dt
    g[1].widgets.btnClickMe.text = "Time: "..tostring(math.floor(t))
    if math.floor(t)%2 == 0 then
        g[1].widgets.btnClickMe.style.borderColor = Y.rgb(255, 0, 0)
    else 
        g[1].widgets.btnClickMe.style.borderColor = Y.rgb(0, 255, 0)
    end
    g[1]:recalculate()
end

function love.mousepressed( x, y, button, istouch, presses )
    g[sel]:handleClick(x, y, button)
end