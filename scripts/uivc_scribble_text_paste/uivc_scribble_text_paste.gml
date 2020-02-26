/// @param UIButton

var button = argument0;
var mode = Stuff.scribble;

mode.scribble_text = clipboard_get_text();
mode.ui.el_scribble_text.value = mode.scribble_text;