/// @param UIThing
function dmu_dialog_change_graphic_general(argument0) {

    var button = argument0;
    var list = button.root.el_list;
    var selection = ui_list_selection(list);

    if (selection + 1) {
        var fn = get_open_filename_image();
        if (file_exists(fn)) {
            var data = list.entries[| selection];
            var remove_back = !keyboard_check_direct(vk_control);
            sprite_delete(data.picture);
            data.picture = sprite_add(fn, 0, remove_back, false, 0, 0);
            uivc_list_graphic_generic(list);
        
            data_image_force_power_two(data);
            data_image_npc_frames(data);
        
            data.width = min(data.width, sprite_get_width(data.picture));
            data.height = min(data.height, sprite_get_height(data.picture));
            if (button.root.el_image) button.root.el_image.image = data.picture;
            if (button.root.el_dim_x) button.root.el_dim_x.value_upper = sprite_get_width(data.picture);
            if (button.root.el_dim_y) button.root.el_dim_y.value_upper = sprite_get_height(data.picture);
            if (button.root.el_dim_x) button.root.el_dim_x.value = string(sprite_get_width(data.picture));
            if (button.root.el_dim_y) button.root.el_dim_y.value = string(sprite_get_height(data.picture));
            if (button.root.el_dimensions) button.root.el_dimensions.text = "Dimensions: " + string(sprite_get_width(data.picture)) + " x " + string(sprite_get_height(data.picture));
        }
    }


}
