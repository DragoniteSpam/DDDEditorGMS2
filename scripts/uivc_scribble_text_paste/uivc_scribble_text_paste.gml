/// @param UIButton

var button = argument0;
var mode = Stuff.scribble;

mode.scribble_text = clipboard_get_text();
// keyboard_string isn't allowed to be any longer than this
if (string_length(mode.scribble_text) > 0x400) {
    mode.scribble_text = string_copy(mode.scribble_text, 1, 0x400);
}
keyboard_string = mode.scribble_text;
mode.ui.el_scribble_text.value = mode.scribble_text;