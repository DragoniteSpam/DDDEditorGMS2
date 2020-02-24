/// @param UIList

var list = argument0;
var selection = ui_list_selection(list);

if (selection + 1) {
    var what = list.entries[| selection];
    
    ui_input_set_value(list.root.el_name, what.name);
    ui_input_set_value(list.root.el_name_internal, what.internal_name);
    ui_input_set_value(list.root.el_frames_horizontal, string(what.hframes));
    ui_input_set_value(list.root.el_frames_vertical, string(what.vframes));
    if (list.root.el_frame_speed) {
        ui_input_set_value(list.root.el_frame_speed, string(what.aspeed));
    }
    list.root.el_image.image = what.picture;
    list.root.el_dimensions.text = "Dimensions: " + string(sprite_get_width(what.picture)) + " x " + string(sprite_get_height(what.picture));
    list.root.el_texture_exclude.value = what.texture_exclude;
    list.root.el_dim_x.value = string(what.width);
    list.root.el_dim_y.value = string(what.height);
}