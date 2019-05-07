/// @description  void ui_render_text_mesh_ymin(UIText, x, y);
/// @param UIText
/// @param  x
/// @param  y

if (data_vra_exists()){
    var data=Stuff.vra_data[? Stuff.all_mesh_names[| Camera.selection_fill_mesh]];
    argument0.text="ymin: "+string(data[@ MeshArrayData.YMIN]);
}

ui_render_text(argument0, argument1, argument2);
