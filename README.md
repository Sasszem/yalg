# YALG
Yet another Löve2D GUI framework

My goal is to make a simple way to build GUI interfaces with Löve2D

Project goals:
- Simple
- Flexible
- Not TOO resource heavy
- Finish project quick (I tend to abandon my projects, so before I got bored on this...)
- "Reactive" GUI - no manual placement of the widgets should be required
- Easy to extend

**CURRENTLY I AM IN THE DRAFTING PHASE, SO APIs, OR EVEN FEATURES CAN CHANGE!
YOU CAN NOT EVEN TAKE THIS DOCUMENT AS GRANTED!**

Check out the [tutorial](TUTORIAL.MD) for a better document!


## Widget internal API
- draw(x, y, w, h) - draw the element in a box.
Handles placement as well
- setParent(parent) - set the widgets parent
- calculateGeometry()
- getMinimumDimensions()
- getContentDimensions()
- w, h
- style

### Widget life cycle
- Created via their constructor from bottom-up (elements first, then parent containers)
- Called setParent() from top-down (source is GUI)
- called calculateStyle() from top-down
- called getMinDimensions() from top-down
Returns minimum dimensions, containers calculate them before return
- called calculateGeometry(x, y, w, h) by parent
Sets own values

- called draw() repedately

### Known gotchas
- spaces in the beginning or end of lines count to the size required
- if you re-use styles in a table, modifying that table later does NOT modify the styles