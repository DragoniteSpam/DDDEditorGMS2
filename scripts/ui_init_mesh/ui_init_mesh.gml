/// @param EditorModeMesh

var mode = argument0;

with (instance_create_depth(0, 0, 0, UIThing)) {
    var columns = 4;
    var spacing = 16;
    
    var cw = (room_width - columns * 32) / columns;
    var ew = cw - spacing * 2;
    var eh = 24;
    
    var c1x = cw * 0 + spacing;
    var c2x = cw * 1 + spacing;
    var c3x = cw * 2 + spacing;
    var c4x = cw * 3 + spacing;
    
    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;
    
    var b_width = 128;
    var b_height = 32;
    
    var yy_header = 64;
    var yy = 64 + eh;
    var yy_base = yy;
    
    var this_column = 0;
    var xx = this_column * cw + spacing;
    
    element = create_button(c1x, yy, "Vertex Formats", ew, eh, fa_center, null, id);
    ds_list_add(contents, element);
    yy += element.height + spacing;
    
    var element = create_list(c1x, yy, "Meshes:", "no meshes", ew, eh, 28, null, true, id, Stuff.all_meshes);
    element.render_colors = ui_list_colors_mesh_type_smf_disabled;
    element.entries_are = ListEntries.INSTANCES;
    mesh_list = element;
    ds_list_add(contents, element);
    yy += ui_get_list_height(element) + spacing;
    
    element = create_button(c1x, yy, "Add Mesh", ew, eh, fa_center, null, id);
    element.file_dropper_action = uifd_load_meshes;
    ds_list_add(contents, element);
    yy += element.height + spacing;
    
    element = create_button(c1x, yy, "Remove Mesh", ew, eh, fa_center, null, id);
    ds_list_add(contents, element);
    yy += element.height + spacing;
    
    yy = yy_base;
    
    element = create_button(c2x, yy, "Export Selected", ew, eh, fa_center, omu_export_meshes_selected, id);
    ds_list_add(contents, element);
    yy += element.height + spacing;
    
    element = create_radio_array(c2x, yy, "Model type to save:", ew, eh, uivc_radio_mesh_export_type, mode.export_type, id);
    create_radio_array_options(element, ["GameMaker model (d3d)", "OBJ model file (obj)", "Vertex buffer (vbuff)"]);
    element.tooltip = @"You may convert to several different types of 3D model files.
- [c_blue]GameMaker model files[/c] (d3d or gmmod) are the format used by the model loading function of old versions of GameMaker, as well as programs like Model Creator for GameMaker.
- [c_blue]OBJ model files[/c] are a very common 3D model format which can be read by most 3D modelling programs such as Blender.
- [c_blue]Vertex buffer files[/c] contain raw (binary) vertex data, and may be loaded into a game quickly without a need for parsing.
If you loaded a model containing SMF data, it will be saved as is without conversion.";
    ds_list_add(contents, element);
    yy += ui_get_radio_array_height(element) + spacing;
    
    element = create_text(c2x, yy, "Editing", ew, eh, fa_center, ew, id);
    ds_list_add(contents, element);
    yy += element.height + spacing;
    
    element = create_button(c2x, yy, "Rotate Up Axis", ew, eh, fa_center, omu_meshes_rotate_up_axis, id);
    ds_list_add(contents, element);
    yy += element.height + spacing;
    
    element = create_input(c2x, yy, "Scale:", ew, eh, omu_meshes_draw_scale, mode.draw_scale, "float", validate_double, 0.01, 100, 5, vx1, vy1, vx2, vy2, id);
    ds_list_add(contents, element);
    mesh_scale = element;
    yy += element.height + spacing;
    
    element = create_button(c2x, yy, "Apply Scale", ew, eh, fa_center, omu_meshes_set_scale, id);
    ds_list_add(contents, element);
    yy += element.height + spacing;
    
    yy = yy_base;
    
    element = create_render_surface(c3x, yy, ew * 2, ew * 2, ui_render_surface_render_mesh_ed, ui_render_surface_control_mesh_ed, c_black, id);
    ds_list_add(contents, element);
    yy += element.height + spacing;
    
    element = create_checkbox(c3x, yy, "Use Textures?", ew, eh, omu_meshes_use_textures, mode.use_textures, id);
    ds_list_add(contents, element);
    yy += element.height + spacing;
    
    return id;
}