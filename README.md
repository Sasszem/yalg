# YALG
Yet another Löve2D GUI framework

My goal was to make a simple way to build GUI interfaces with Löve2D.
My goal was **NOT** to build a fancy or extensive GUI lib, just a quick way of building simple menus with a few buttons. Of course, it can be "abused" to do more (just look at the config example!).

Look at the [screenshots](screenshots) folder for some example looks!

### Project goals:
- Simple
- Flexible
- Not TOO resource heavy
- Finish project quick (I tend to abandon my projects, so before I got bored on this...)
- "Reactive" GUI - no manual placement of the widgets should be required
- Easy to extend
- pure LÖVE2D - no external dependencies, portable even to android

### Project status
I consider this "finished", I do not plan any more features in this project. I am still open for issue reports & maybe even to some ideas.
I used this lib in two other projects, [13](https://github.com/sasszem/13) and [crossfire](https://github.com/sasszem/crossfire) sucessfuly.

## Documentation
Check out the [tutorial](TUTORIAL.MD) for a quickstart!

Check out the [internal api documentation](DOCS.md) for implementation details.

### Known gotchas
- spaces in the beginning or end of lines count to the size required
- if you re-use styles in a table, modifying that table later does NOT modify the styles
(this is intentional, this way you can modify each individual element separately)

### Conclusion - what'll I do differently next time
(note to self and a lesson for other idiots doing stuff like this)
I'm already planning another framework in my head, so expect it in the next 1-5 years.
It might not be in Lua and Löve at all.
Some things I'll do differently:
- do NOT pullute global namespace
- somehow make owerflows work
- more, MORE event handlers - update, resize, focus in/out, selected, deselected, create, destroy...
- maybe move from declarative style to layout description files (or might as well just write a HTML renderer)
- more built-in widgets
- built in colors
- easier style switching
- widget protoyping
- better container division - the fractional pattern I used does not work that well
