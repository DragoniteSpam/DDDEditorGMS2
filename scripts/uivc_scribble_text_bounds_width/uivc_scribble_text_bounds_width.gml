/// @param UIProgressBar

var bar = argument0;
var mode = Stuff.scribble;

mode.scribble_bounds_width = bar.value;
mode.scribble = noone;
scribble_cache_group_flush(SCRIBBLE_DEFAULT_CACHE_GROUP);