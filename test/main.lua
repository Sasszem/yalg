require("gui")

local g = {}

g[1] = GUI(
    HDiv(
        Label("A label"),
        Button("Click me!", {font=Font(40), textColor=rgb(255, 0, 0), placement="center", id="btnClickMe"})
    ),
    HDiv(
        Label("Another label"),
        Button("Do NOT click me!",{textColor=rgb(0,0,255), border=9, borderColor=rgb(0,255,0), backgroundColor=rgb(50,50,50)}),
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
        placement="center"
    }
)

g[3] = GUI(
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
        }),
        Label("", {
            backgroundColor = rgb(255, 255, 255),
        })
    )
)

for k, v in pairs(g[1].widgets) do
    print(k, v)
end

function love.load()
    love.window.setMode( 800, 600, {resizable=true, minwidth=100, minheight=100})
end

local sel = 1

local t = 0

function love.draw() 
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
    t = t + dt
    g[1].widgets.btnClickMe.text = "Time: "..tostring(math.floor(t))
    if math.floor(t)%2 == 0 then
        g[1].widgets.btnClickMe.style.borderColor = rgb(255, 0, 0)
    else 
        g[1].widgets.btnClickMe.style.borderColor = rgb(0, 255, 0)
    end
    g[1]:recalculate()
end