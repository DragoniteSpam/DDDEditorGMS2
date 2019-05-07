/// @description  void ui_render_text_mesh_label(UIText, x, y);
/// @param UIText
/// @param  x
/// @param  y

if (data_vra_exists()){
    argument0.text=Stuff.all_mesh_names[| Camera.selection_fill_mesh];
}

ui_render_text(argument0, argument1, argument2);
