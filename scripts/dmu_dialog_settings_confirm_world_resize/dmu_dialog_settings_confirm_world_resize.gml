/// @param UIThing

var thing = argument0;
var data_map = thing.root.data;
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

for (var i = 0; i < ds_list_size(map.all_entities); i++) {
    var thing = map.all_entities[| i];
    if (thing.xx >= xx || thing.yy >= yy || thing.zz >= zz) {
        safa_delete(thing);
    }
}

dialog_destroy();
dialog_destroy();

dc_settings_execute(thing.root.root);