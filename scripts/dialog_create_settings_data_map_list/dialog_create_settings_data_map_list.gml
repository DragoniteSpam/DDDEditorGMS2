/// @description  void dialog_create_settings_data_map_list(UIList);
/// @param UIList

var data_maps=ds_map_to_list_sorted(Stuff.all_maps);

ui_list_clear(argument0);

for (var i=0; i<ds_list_size(data_maps); i++){
    if (Stuff.game_map_starting==data_maps[| i]){
        var c=c_blue;
    } else {
        var c=c_black;
    }
    create_list_entries(argument0, data_maps[| i], c);
}

ds_list_destroy(data_maps);
