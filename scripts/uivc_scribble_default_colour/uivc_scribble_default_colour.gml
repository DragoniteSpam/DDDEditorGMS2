/// @param UIColorPicker

var picker = argument0;
var mode = Stuff.scribble;

mode.scribble_default_colour = picker.value;
mode.scribble = noone;
scribble_cache_group_flush(SCRIBBLE_DEFAULT_CACHE_GROUP);