/// @description  void ui_render_text_autotile_tag(UIText, x, y);
/// @param UIText
/// @param  x
/// @param  y

var ts=get_active_tileset();

if (ts.autotiles[Camera.selection_fill_autotile]!=noone){
    argument0.text=all_tile_terrain_tag_names[ts.at_tags[Camera.selection_fill_autotile]];
}

ui_render_text(argument0, argument1, argument2);
