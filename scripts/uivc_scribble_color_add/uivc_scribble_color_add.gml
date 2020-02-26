/// @param UIButton

var button = argument0;
var list = button.root.el_list;
var mode = Stuff.scribble;

var n = 1;
do {
    var cname = "c_" + string(ds_list_size(list.entries) + n++);
} until (!ds_map_exists(global.__scribble_colours, cname));
ds_list_add(list.entries, cname);
global.__scribble_colours[? cname] = c_black;

button.root.el_remove.interactive = true;
button.interactive = (ds_list_size(list.entries) < 0xff);
mode.scribble = noone;
scribble_cache_group_flush(SCRIBBLE_DEFAULT_CACHE_GROUP);