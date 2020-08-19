/// @param UIButton
function uivc_button_settings_game_add_asset_file(argument0) {

    var button = argument0;
    var list_main = button.root.el_list;

    if (ds_list_size(list_main.entries) < 0xff) {
        var base_name = "data";
        var name = base_name;
        var n = 1;
        while (internal_name_get(name)) {
            name = base_name + string(n++);
        }
        ds_list_add(list_main.entries, create_data_file(name, false));
        button.interactive = (ds_list_size(list_main.entries) < 0xff);
        button.root.el_remove.interactive = (ds_list_size(list_main.entries) > 0x01);
    }


}
