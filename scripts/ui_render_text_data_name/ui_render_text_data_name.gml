/// @param UIText
/// @param x
/// @param y

var text = argument0;
var xx = argument1;
var yy = argument2;

if (text.root.active_type_guid) {
    text.text = guid_get(text.root.active_type_guid).name;
} else {
    text.text = "No Data Selected";
}

ui_render_text(text, xx, yy);