# YALG
Yet another Löve2D GUI framework

My goal is to make a simple way to build GUI interfaces with Löve2D.
My goal is **NOT** to build a fancy or extensive GUI lib, just a quick way of building simple menus with a few buttons. Of course, it can be "abused" to do more (just look at the config example!).

### Project goals:
- Simple
- Flexible
- Not TOO resource heavy
- Finish project quick (I tend to abandon my projects, so before I got bored on this...)
- "Reactive" GUI - no manual placement of the widgets should be required
- Easy to extend

### Project status
I consider this "finished", I do not plan any more features in this project. I am still open for issue reports & maybe even to some ideas.

## Documentation
Check out the [tutorial](TUTORIAL.MD) for a quickstart!

Check out the [internal api documentation](DOCS.md) for implementation details.

### Known gotchas
- spaces in the beginning or end of lines count to the size required
- if you re-use styles in a table, modifying that table later does NOT modify the styles