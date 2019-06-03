/// @description void ui_render_text_data_name(UIText, x, y);
/// @param UIText
/// @param x
/// @param y

if (argument0.root.active_type_guid == 0) {
    argument0.text = "No Data Selected";
} else {
    argument0.text = guid_get(argument0.root.active_type_guid).name;
}

ui_render_text(argument0, argument1, argument2);
