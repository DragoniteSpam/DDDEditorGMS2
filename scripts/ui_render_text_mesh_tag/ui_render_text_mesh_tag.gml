/// @param UIText
/// @param x
/// @param y

var data = Stuff.all_meshes[| Camera.selection_fill_mesh];
argument0.text = get_active_tileset().terrain_tag_names[| data.tags];

ui_render_text(argument0, argument1, argument2);