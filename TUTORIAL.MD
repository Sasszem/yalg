# Getting started guide

### Installing
The intended way of installing yalg is in a separate folder in your main project folder. You might use a git submodule to keep your copy up-to-date.

### Importing

To import yalg, you only need to require the top-module "yalg" module, like so:

```lua
require("lib.yalg")
```
This also imports all widgets and helper functions, like `rgb()`

## GUI layout creation
GUI layout can be built using the widgets in a declarative style

```lua
local g = GUI(
    Button("A button"),
    Button("Another button")
)
```

### The widgets
Currently, YALG has 5 different widget types
- Button
- Label
- VDiv
- HDiv
- Switcher


### Containers
`VDiv`, `HDiv`, `Switcher` and `GUI` are container widgets. (`GUI` is a special case of `VDiv`) 

`VDiv`, `HDiv` and `GUI` are layout containers, as they divide their space (by default, evenly), and place their child elements in those slots.

`Switcher` is a special element that holds multiple elements, and can switch between them.

To add elements in a container, you just pass the child elements to the constructor:
```lua
local g = GUI(
    Button("A button"),
    HDiv(
        Label("A label"),
        Button("Another button")
    )
)
```

### Button and Label
`Button`s and `Label`s are nearly the same, boxes with some text.
(In fact, the only difference between them is their degault style)

To set a `Button`'s or a `Label`'s text you only have to pass that text to their constructor.
(I will not provide the same example again)

## IDs
Widget IDs can be used to access the widgets later for example, to modify style or text.
IDs are also used with the switcher to specify which style to select.
To set IDs, you simply pass an additional string argument after the style to the widget constructor.
```lua
local g = GUI(
    Label("Text", {}, "labelID")
)
```
To access an element later, simply use the `widgets` attribute of GUI:
```lua
local l = g.widgets["labelID"]
```
or
```lua
local l = g.widgets.labelID
```
You can modify styles or text later this way.

## Switcher
Switcher is a special widget that can switch between different child widgets.
The default one is the first child.
The `selected` property specifies which child is active. It should be set to the ID of the child.

## Styles
The default look if the widgets might not be the best one for you. By adding styles, you can customize the look of each inividual element.

You might also re-use styles in between elements to provide a more uniform look in your GUI.
(note: if you do this, modifying the shared style later will NOT change the widgets' apperance)

To set a style, you only have to pass a table as an additional argument to that element's constructor:
```lua
g = GUI(
    Button("I am red!", {
        textColor = rgb(255, 0, 0)
    }),
    Button("I am green", {
        textColor = rgb(0, 255, 0)
    }),
    Button("I am blue", {
        textColor = rgb(0, 0, 255)
    })
)
```

Styles are NOT inherited from containers to child elements, **except for fonts**.

For color, you can use the provided `rgb(r, g, b, a=255)` helper function.

### Box model

Inspired by the CSS box model, YALG uses a similar one

Layers, from inside to out:
- content (text, or child widgets)
- padding
- border (color set by borderColor)
- margin (does not have background drawn)

Each attribute can be set in the style accordingly

Custon width & height can also be set via styles, that override calculated ones if they are bigger.

### Placement

Placement defines what to do in the (very common) case the widget does not fully fill the parent container. It can have two different values:
- center
- fill
Fill only fills parent container, it will NOT cause the parent to fill it's parent.

### Colors
- borderColor
- textColor
- backgroundCOlor
Each should be set via the `rgb()` helper function

### Text
- font
Should be set via the `Font(size, font)` helper.
Fonts are cached internally. The second argument is optional, and is the same as `love.graphics.newFont`'s.
(guess what I use internally)

### Container layout
- gap - specifies the gap between child containers
- slots - specifies minimum number of slots to divide space into
- span - set on the child, specifies how many slots of parent container to fill

### Event handlers
Event handler functions can be used to make the GUI interactive
- click(self, x, y, button)
- mouseEnter(self, x, y)
- mouseLeave(self, x, y)

To set a callback, you only have to provide a function via the style table:
```lua
local g = GUI(
    Label("A label", 
    {
        click = function(self, x, y, button)
            self.text = "Secret feature"
        end
    })
)
```

You can use IDs to set callbacks:
```lua
local g = GUI(
    Label("A label", {}, "label")
)

function g.widgets.label.style.click(self, x, y, button)
    self.text = "Hidden feature"
end
```

You can also use lua's colon syntax this way:
```lua
function g.widgets.label.style:click(x, y, button)
    self.text = "Hidden feature"
end
```

#### List of all style attributes

Layout:
- width
- height
- placement
- margin
- border
- borderColor
- padding
- backgroundColor

Text:
- font
- textColor

Container layout:
- gap
- span
- slots

Event handlers:
- mouseEnter
- mouseLeave
- click