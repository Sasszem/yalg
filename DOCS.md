## Widget internal API
- `draw()` - draw the element
- `setParent(parent)` - set the widgets parent
- `calculateGeometry(x, y, w, h)` - calculate placement inside a box
- `getMinDimensions()` - get the minimum space required by the Widget, including padding, border & margin
- `getContentDimensions()` - get the minimum space required for the content of the widget, without anywhing else
- `getContentBox()` - get the box to draw the contents in
- `inside(x, y)` - check if a point is inside the widget or not. Used for mouse events.
- `handleMouse(x, y)` - handle mouse (fire enter or leave events)
- `handleClick(x, y, button)` - fire click event if inside
- `getFont()` - get the font or the parent's font
- `getWidget(id)` - get a widget with a given ID from the hierarchy
- `addWidgetLookup(key, widget)` - register a widget with an ID in the hierarcy (containers only)
- `getSlots()` - get the required slots to divide space into (containers only)

### GUI API
- `update()` - do mouse updating
- `recalculate()` - recalculate all geometry
- `resize(w, h)` - resize & recalculate
- `handleClick(x, y, button)` - forward a click event

### Widget attributes
- `x`, `y`, `w`, `h` - only after set by `calculateGeomery`
- `style`
- `id`
- `mouseOver`
- `parent`
- `text` (in case of `Labels` and `Buttons`)
- `widgets` (in case of `Switchers` and `GUI`)
- `items` (in case of all containers)
- `selected` (`Switcher` only)

Note: setting of any other attribute than those is possible.

### Helper functions
- `Font(size, file)` - create a cached font with `love.graphics.newFont(size, file)`. Second parameter is optional
- `rgb(r, g, b, a)` - RGB helper, divide each component by 255 and return as a table. Alpha is optional, defaults to 255.
- `getId(type)` - generate a new string Id for a widget, based on it's type
- `centerBox(bX, bY, bW, bH, w, h)` center a `(w, h)` sized box inside another. Returns `(x, y)` of top left corner to place.

### Widget life cycle
- Created via their constructor from bottom-up (elements first, then parent containers)
- Called `setParent()` from top-down (source is `GUI`)
- called `calculateGeometry(x, y, w, h)` by parent
Sets own values
- called `draw()` repedately
- called `handleMouse(x, y)` by parent (source is GUI, if `update()` is called)
- called `handleClick(x, y, w, h)` by parent (source is GUI, if `handleClick(x, y, button)` is called on it)
- called `calculateGeometry(x, y, w, h)` by parent in case of recalculation(resize or directly issued)