/// @param UIList

var list = argument0;
var selection = ui_list_selection(list);

if (selection + 1) {
    var what = list.entries[| selection];
    
    ui_input_set_value(list.root.el_name, what.name);
    ui_input_set_value(list.root.el_name_internal, what.internal_name);
    ui_input_set_value(list.root.el_frames_horizontal, string(what.hframes));
    ui_input_set_value(list.root.el_frames_vertical, string(what.vframes));
    list.root.el_image.image = what.picture;
    list.root.el_dimensions.text = "Dimensions: " + string(what.width) + " x " + string(what.height);
}