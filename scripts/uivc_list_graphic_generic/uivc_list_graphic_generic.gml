function uivc_list_graphic_generic(list) {
    var selection = ui_list_selection(list);
    if (selection + 1) {
        // direct references to the texture images are dealt with elsewhere
        var what = list.entries[| selection];
        ui_input_set_value(list.root.el_name, what.name);
        ui_input_set_value(list.root.el_name_internal, what.internal_name);
        ui_input_set_value(list.root.el_frames_horizontal, string(what.hframes));
        ui_input_set_value(list.root.el_frames_vertical, string(what.vframes));
        ui_input_set_value(list.root.el_frame_speed, string(what.aspeed));
        list.root.el_texture_exclude.value = what.texture_exclude;
        list.root.el_dim_x.value = string(what.width);
        list.root.el_dim_y.value = string(what.height);
        list.root.el_dim_x.value_upper = sprite_get_width(what.picture);
        list.root.el_dim_y.value_upper = sprite_get_height(what.picture);
    }
}