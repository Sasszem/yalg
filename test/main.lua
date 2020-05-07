require("yalg")

local g = {}

g[1] = GUI(
    HDiv(
        Label("A label"),
        Button("Click me!", {
            font=Font(40),
            textColor=rgb(255, 0, 0), 
            id="btnClickMe"
        })
    ),
    HDiv(
        Label("Another label"),
        Button("Do NOT click me!",{
            placement="fill",
            textColor=rgb(0,0,255),
            border=9,
            borderColor=rgb(0,255,0),
            backgroundColor=rgb(50,50,50),
            mouseEnter = function(self, x, y)
                if self.text~="F U" then
                    self.text = "DO NOT EVEN TRY!"
                end
            end,
            mouseLeave = function (self, x, y)
                if self.text~="F U" then
                    self.text = "Do NOT click me!"
                end
            end,
            click = function (self, x, y)
                self.text = "F U"
            end
        }),
        {
            font=Font(40),
        }
    ),
    {
        font=Font(20),
    }
)
g[2] = GUI(
    Button("New Game", {placement="fill"}),
    Button("Highscores", {placement="fill"}),
    Button("Quit", {placement="fill"}),
    {
        font=Font(30),
        placement="center",
        gap = 10,
    }
)

g[3] = GUI(
    Button("New Game", {padding=30, placement="fill"}),
    Button("Highscores", {padding=0, placement="fill"}),
    Button("Quit", {placement="fill"}),
    {
        font=Font(30),
        backgroundColor = rgb(0, 255, 0),
        gap=20,
    }
)

g[4] = GUI(
    HDiv(
        Label("", {
            backgroundColor = rgb(255, 0, 0),
        }),
        Label("", {
            backgroundColor = rgb(0, 255, 0),
        })
    ),
    HDiv(
        Label("", {
            backgroundColor = rgb(0, 0, 255),
            click = function (self, x, y, button)
                self.style.backgroundColor[1] = 1 - self.style.backgroundColor[1]
            end
        }),
        Label("", {
            backgroundColor = rgb(255, 255, 255),
        })
    )
)

g[5] = GUI(
    HDiv(
        Label("I'm just a Label!"),
        Button("And I'm a Button"),
        {
            margin = 20,
            border = 4,
            borderColor = rgb(0, 255, 0),
        }
    ),
    HDiv(
        Label("Lonely label here...")
    ),
    {
        border = 3,
        borderColor = rgb(0,0,255)
    }
)

g[#g + 1] = GUI(
    HDiv(
        Button("Left button", {placement="fill", margin=1}),
        Button("Right button", {placement="center"}),
        {
            placement="center",
            border=5,
            backgroundColor = rgb(255, 255, 255),
            borderColor=rgb(0,0,255),
        }
    )
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
        g[1].widgets.btnClickMe.style.borderColor = rgb(255, 0, 0)
    else 
        g[1].widgets.btnClickMe.style.borderColor = rgb(0, 255, 0)
    end
    g[1]:recalculate()
end

function love.mousepressed( x, y, button, istouch, presses )
    g[sel]:handleClick(x, y, button)
end