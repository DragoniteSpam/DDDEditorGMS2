/// @param UIText
/// @param x
/// @param y
function ui_render_text_stats_entities(argument0, argument1, argument2) {

    var text = argument0;
    var xx = argument1;
    var yy = argument2;

    text.text = string(ds_list_size(Stuff.map.active_map.contents.all_entities));

    ui_render_text(text, xx, yy);


}
