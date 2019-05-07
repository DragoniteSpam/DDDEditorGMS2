/// @description  void ui_render_text_mesh_tag(UIText, x, y);
/// @param UIText
/// @param  x
/// @param  y

if (data_vra_exists()){
    var data=Stuff.vra_data[? Stuff.all_mesh_names[| Camera.selection_fill_mesh]];
    argument0.text=all_tile_terrain_tag_names[data[@ MeshArrayData.TAGS]];
}

ui_render_text(argument0, argument1, argument2);
