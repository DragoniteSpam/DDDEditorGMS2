/// @param Dialog
// Doesn't actually commit any settings, just a verification to see if there
// would be any side effects (entities being orphaned by the grid, etc) and
// if there are, pops up a confirmation asking if you want to (safely) do it anyway.

var dialog = argument0;
var data_map = dialog.data;
var map = Stuff.active_map;

var xx = map.xx;
var yy = map.yy;
var zz = map.zz;
if (ds_map_exists(data_map, "x")) {
    xx = data_map[? "x"];
}
if (ds_map_exists(data_map, "y")) {
    yy = data_map[? "y"];
}
if (ds_map_exists(data_map, "z")) {
    zz = data_map[? "z"];
}

var oob = ds_list_create();
for (var i = 0; i < ds_list_size(map.all_entities); i++) {
    var thing = map.all_entities[| i];
    if (thing.xx >= xx || thing.yy >= yy || thing.zz >= zz) {
        ds_list_add(oob, thing);
    }
}

selection_clear();

if (!ds_list_empty(oob)) {
    dialog_create_settings_confirm_world_resize(dialog);
} else {
    // normally when you do this kind of thing you'd want to destroy the
    // oob list (or other dynamic resources) first, but this doesn't
    // actually destroy the dialog, just informs the program that it needs
    // to be destroyed after everything has been rendered
    dialog_destroy();
    dc_settings_execute(dialog);
}

ds_list_destroy(oob);