/// @param UIList

var list = argument0;
var data_maps = ds_map_to_list_sorted(Stuff.all_maps);

ui_list_clear(list);

for (var i = 0; i < ds_list_size(data_maps); i++) {
    var c = (Stuff.game_map_starting == data_maps[| i]) ? c_blue : c_black;
    create_list_entries(list, data_maps[| i], c);
}

ds_list_destroy(data_maps);