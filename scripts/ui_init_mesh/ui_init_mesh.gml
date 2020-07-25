/// @param EditorModeMesh

var mode = argument0;

with (instance_create_depth(0, 0, 0, UIThing)) {
    var columns = 4;
    var spacing = 16;
    
    var cw = (room_width - columns * 32) / columns;
    var ew = cw - spacing * 2;
    var ew0 = cw + spacing * 2;
    var eh = 24;
    
    var c1x = cw * 0 + spacing;
    // the first column is a bit wider
    var c2x = cw * 1 + spacing + spacing * 4;
    var c3x = cw * 2 + spacing + spacing * 4;
    var c4x = cw * 3 + spacing + spacing * 4;
    
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
    
    var element = create_list(c1x, yy, "Meshes:", "no meshes", ew0, eh, 22, null, true, id, Stuff.all_meshes);
    element.tooltip = "All of the 3D meshes currently loaded. You can drag them from Windows Explorer into the program window to add them in bulk. Middle-click the list to alphabetize the meshes.";
    element.render_colors = ui_list_colors_mesh_type_smf_disabled;
    element.onmiddleclick = omu_meshes_alphabetize_meshes;
    element.evaluate_text = ui_list_text_meshes_with_data;
    element.entries_are = ListEntries.SCRIPT;
    mesh_list = element;
    ds_list_add(contents, element);
    yy += ui_get_list_height(element) + spacing;
    
    element = create_button(c1x, yy, "Add Mesh", ew0, eh, fa_center, omu_mesh_editor_add, id);
    element.tooltip = "Add a 3D mesh. You can drag them from Windows Explorer into the program window to add them in bulk.";
    element.file_dropper_action = uifd_load_meshes;
    ds_list_add(contents, element);
    yy += element.height + spacing;
    
    element = create_button(c1x, yy, "Remove Mesh", ew0, eh, fa_center, omu_mesh_editor_remove, id);
    element.tooltip = "Remove the selected 3D meshes.";
    ds_list_add(contents, element);
    yy += element.height + spacing;
    
    element = create_button(c1x, yy, "Export Selected", ew0, eh, fa_center, omu_export_meshes_selected, id);
    element.tooltip = "Export the selected 3D meshes to the specified format. You can use this to convert from one 3D model format to another.";
    ds_list_add(contents, element);
    yy += element.height + spacing;
    
    element = create_radio_array(c1x, yy, "Model type to save:", ew0, eh, uivc_radio_mesh_export_type, mode.export_type, id);
    create_radio_array_options(element, ["GameMaker model (d3d)", "OBJ model file (obj)", "Vertex buffer (vbuff)"]);
    element.tooltip = @"You may convert to several different types of 3D model files.
- [c_blue]GameMaker model files[/c] (d3d or gmmod) are the format used by the model loading function of old versions of GameMaker, as well as programs like Model Creator for GameMaker.
- [c_blue]OBJ model files[/c] are a very common 3D model format which can be read by most 3D modelling programs such as Blender.
- [c_blue]Vertex buffer files[/c] contain raw (binary) vertex data, and may be loaded into a game quickly without a need for parsing. (You can define a vertex format to export the model with.)
If you loaded a model containing SMF data, it will be saved as is without conversion.";
    ds_list_add(contents, element);
    yy += ui_get_radio_array_height(element) + spacing;
    
    yy = yy_base;
    
    element = create_text(c2x, yy, "[c_blue]Vertex Formats", ew, eh, fa_left, ew, id);
    ds_list_add(contents, element);
    yy += element.height + spacing;
    
    element = create_list(c2x, yy, "Available Vertex Formats", "no vertex formats", ew, eh, 6, null, false, id, mode.format_names);
    element.tooltip = "Vertex formats available to be exported to. Extra fields beyond the original position / normal / texture / color will be set to zero.";
    element.ondoubleclick = omu_meshes_edit_vertex_format;
    ds_list_add(contents, element);
    format_list = element;
    yy += ui_get_list_height(element) + spacing;
    
    element = create_button(c2x, yy, "Add Vertex Format", ew, eh, fa_center, omu_meshes_add_vertex_format, id);
    element.tooltip = "Mirror the selected meshes over the Z axis.";
    ds_list_add(contents, element);
    yy += element.height + spacing;
    
    element = create_button(c2x, yy, "Edit Vertex Format", ew, eh, fa_center, omu_meshes_edit_vertex_format, id);
    element.tooltip = "Mirror the selected meshes over the Z axis.";
    ds_list_add(contents, element);
    yy += element.height + spacing;
    
    element = create_button(c2x, yy, "Remove Vertex Format", ew, eh, fa_center, omu_meshes_remove_vertex_format, id);
    element.tooltip = "Mirror the selected meshes over the Z axis.";
    ds_list_add(contents, element);
    yy += element.height + spacing;
    
    element = create_text(c2x, yy, "[c_blue]Editing", ew, eh, fa_left, ew, id);
    ds_list_add(contents, element);
    yy += element.height + spacing;
    
    element = create_button(c2x, yy, "Rotate Up Axis", ew, eh, fa_center, omu_meshes_rotate_up_axis, id);
    element.tooltip = "Rotate the \"up\" axis for the selected meshes. It would be nice if the world could standardize around either Y-up or Z-up, but that's never going to happen.";
    ds_list_add(contents, element);
    yy += element.height + spacing;
    
    element = create_input(c2x, yy, "Scale:", ew, eh, omu_meshes_draw_scale, mode.draw_scale, "float", validate_double, 0.01, 100, 5, vx1, vy1, vx2, vy2, id);
    element.tooltip = "Set the scale used by the preview on the right. If you want to apply the scale to the selected meshes permanently, click the button below.";
    ds_list_add(contents, element);
    mesh_scale = element;
    yy += element.height + spacing;
    
    element = create_button(c2x, yy, "Apply Scale", ew, eh, fa_center, omu_meshes_set_scale, id);
    element.tooltip = "Apply the preview scale to the selected meshes. Useful for converting between different scale systems (1 unit = 1 meter vs 32 units = 1 meter, etc).";
    ds_list_add(contents, element);
    yy += element.height + spacing;
    
    element = create_input(c2x, yy, "Rotation (X):", ew, eh, omu_meshes_set_rot_x, mode.draw_rot_x, "float", validate_double, -360, 360, 5, vx1, vy1, vx2, vy2, id);
    element.tooltip = "Rotate the model(s) drawn in the preview window around the X axis.";
    ds_list_add(contents, element);
    mesh_rot_x = element;
    yy += element.height + spacing;
    
    element = create_input(c2x, yy, "Rotation (Y):", ew, eh, omu_meshes_set_rot_y, mode.draw_rot_y, "float", validate_double, -360, 360, 5, vx1, vy1, vx2, vy2, id);
    element.tooltip = "Rotate the model(s) drawn in the preview window around the Y axis.";
    ds_list_add(contents, element);
    mesh_rot_y = element;
    yy += element.height + spacing;
    
    element = create_input(c2x, yy, "Rotation (Z):", ew, eh, omu_meshes_set_rot_z, mode.draw_rot_z, "float", validate_double, -360, 360, 5, vx1, vy1, vx2, vy2, id);
    element.tooltip = "Rotate the model(s) drawn in the preview window around the Z axis.";
    ds_list_add(contents, element);
    mesh_rot_z = element;
    yy += element.height + spacing;
    
    element = create_button(c2x, yy, "Reset Transform", ew, eh, fa_center, omu_meshes_reset_transform, id);
    element.tooltip = "Reset the transform used in the preview.";
    ds_list_add(contents, element);
    yy += element.height + spacing;
    
    element = create_button(c2x, yy, "Mirror X Axis", ew / 3, eh, fa_center, omu_meshes_mirror_x, id);
    element.tooltip = "Mirror the selected meshes over the X axis.";
    ds_list_add(contents, element);
    element = create_button(c2x + ew / 3, yy, "Mirror Y Axis", ew / 3, eh, fa_center, omu_meshes_mirror_y, id);
    element.tooltip = "Mirror the selected meshes over the Y axis.";
    ds_list_add(contents, element);
    element = create_button(c2x + 2 * ew / 3, yy, "Mirror Z Axis", ew / 3, eh, fa_center, omu_meshes_mirror_z, id);
    element.tooltip = "Mirror the selected meshes over the Z axis.";
    ds_list_add(contents, element);
    yy += element.height + spacing;
    
    element = create_button(c2x, yy, "Flip Horizontal Texture Coordinates", ew, eh, fa_center, omu_meshes_flip_tex_h, id);
    element.tooltip = "I don't actually know why you would need to do this, but it's here.";
    ds_list_add(contents, element);
    yy += element.height + spacing;
    
    element = create_button(c2x, yy, "Flip Vertical Texture Coordinates", ew, eh, fa_center, omu_meshes_flip_tex_v, id);
    element.tooltip = "Some 3D modelling programs (I'm looking at you, Blender) insist on using the bottom-left of the texture image as the (0, 0) origin. We prefer the origin to be in the top-left. Use this button to flip the texture coordinates vertically.";
    ds_list_add(contents, element);
    yy += element.height + spacing;
    
    yy = yy_base;
    
    element = create_render_surface(c3x, yy, ew * 2, ew * 1.8, ui_render_surface_render_mesh_ed, ui_render_surface_control_mesh_ed, c_black, id);
    ds_list_add(contents, element);
    yy += element.height + spacing;
    
    var yy_base_rs = yy;
    #region options
    element = create_checkbox(c3x, yy, "Draw filled meshes?", ew, eh, omu_meshes_draw_meshes, mode.draw_meshes, id);
    element.tooltip = "Draw the filled part of the 3D meshes.";
    ds_list_add(contents, element);
    yy += element.height + spacing;
    
    element = create_checkbox(c3x, yy, "Draw wireframes?", ew, eh, omu_meshes_draw_wireframes, mode.draw_wireframes, id);
    element.tooltip = "Draw a wireframe over the 3D mesh. Turn this off if it gets annoying.";
    ds_list_add(contents, element);
    yy += element.height + spacing;
    
    element = create_button(c3x, yy, "Object Materials...", ew, eh, fa_center, omu_meshes_set_textures, id);
    element.tooltip = "Set the textures used by the selected meshes. Only the base texture is available for now; I may implement the others later.";
    ds_list_add(contents, element);
    yy += element.height + spacing;
    
    yy = yy_base_rs;
    
    element = create_checkbox(c4x, yy, "Show Textures?", ew, eh, omu_meshes_draw_textures, mode.draw_textures, id);
    element.tooltip = "Whether or not to draw the meshes in the preview window using a texture.";
    ds_list_add(contents, element);
    yy += element.height + spacing;
    
    element = create_checkbox(c4x, yy, "Show Lighting?", ew, eh, omu_meshes_draw_lighting, mode.draw_lighting, id);
    element.tooltip = "Whether or not to lighting should be enabled.";
    ds_list_add(contents, element);
    yy += element.height + spacing;
    #endregion
    return id;
}