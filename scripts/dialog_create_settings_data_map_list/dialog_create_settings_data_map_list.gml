/// @param UIList

var list = argument0;

ui_list_clear(list);

for (var i = 0; i < ds_list_size(Stuff.all_maps); i++) {
    var c = (Stuff.game_map_starting == Stuff.all_maps[| i]) ? c_blue : c_black;
    create_list_entries(list, [Stuff.all_maps[| i], c]);
}