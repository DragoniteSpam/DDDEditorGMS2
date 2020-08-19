/// @param UIText
/// @param x
/// @param y
function ui_render_text_data_name(argument0, argument1, argument2) {

    var text = argument0;
    var xx = argument1;
    var yy = argument2;

    var val = guid_get(text.root.active_type_guid);
    text.text = val ? val.name : "No Data Selected";

    ui_render_text(text, xx, yy);


}
