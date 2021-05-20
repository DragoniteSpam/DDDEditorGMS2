/// @param UIList
function uivc_list_graphic_generic(argument0) {

    var list = argument0;
    var selection = ui_list_selection(list);

    if (selection + 1) {
        var what = list.entries[| selection];
    
        ui_input_set_value(list.root.el_name, what.name);
        ui_input_set_value(list.root.el_name_internal, what.internal_name);
        if (list.root.el_frames_horizontal) ui_input_set_value(list.root.el_frames_horizontal, string(what.hframes));
        if (list.root.el_frames_vertical) ui_input_set_value(list.root.el_frames_vertical, string(what.vframes));
        if (list.root.el_frame_speed) ui_input_set_value(list.root.el_frame_speed, string(what.aspeed));
        if (list.root.el_dimensions) list.root.el_dimensions.text = "Dimensions: " + string(sprite_get_width(what.picture)) + " x " + string(sprite_get_height(what.picture));
        if (list.root.el_texture_exclude) list.root.el_texture_exclude.value = what.texture_exclude;
        if (list.root.el_dim_x) list.root.el_dim_x.value = string(what.width);
        if (list.root.el_dim_y) list.root.el_dim_y.value = string(what.height);
        if (list.root.el_dim_x) list.root.el_dim_x.value_upper = sprite_get_width(what.picture);
        if (list.root.el_dim_y) list.root.el_dim_y.value_upper = sprite_get_height(what.picture);
    }


}
