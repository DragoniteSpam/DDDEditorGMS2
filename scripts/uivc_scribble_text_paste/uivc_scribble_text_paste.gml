/// @param UIButton

var button = argument0;
var mode = Stuff.scribble;

// keyboard_string isn't allowed to be any longer than 1024 and i don't
// really want to get close to the limit
mode.scribble_text = string_copy(clipboard_get_text(), 1, 1000);
keyboard_string = mode.scribble_text;
mode.ui.el_scribble_text.value = mode.scribble_text;