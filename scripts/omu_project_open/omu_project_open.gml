/// @param UIButton

var button = argument0;

// don't do it right here because you may do things with tileset surfaces and that makes
// bad things happen if you're in the middle of drawing
Stuff.schedule_open = true;

dialog_destroy();