/// @param UIText
/// @param x
/// @param y
function ui_render_text_stats_static(argument0, argument1, argument2) {

    var text = argument0;
    var xx = argument1;
    var yy = argument2;

    text.text = string(Stuff.map.active_map.contents.population_static);

    ui_render_text(text, xx, yy);


}
