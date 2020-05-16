/// @param EditorModeTerrain

var mode = argument0;

with (instance_create_depth(0, 0, 0, UIMain)) {
    home_row_y = 32;
    
    #region setup
    t_general = create_tab("General", 0, id);
    t_lighting = create_tab("Lighting", 0, id);
    t_heightmap = create_tab("Deform", 0, id);
    t_texture = create_tab("Texture", 0, id);
    t_paint = create_tab("Paint", 0, id);
    
    // the game will crash if you create a tab row with zero width.
    var tr_general = ds_list_create();
    ds_list_add(tr_general, t_general, t_lighting, t_heightmap, t_texture, t_paint);
    
    ds_list_add(tabs, tr_general);
    
    active_tab = t_general;
    
    #endregion
    
    // don't try to make three columns. the math has been hard-coded
    // for two. everything will go very badly if you try three or more.
    var element;
    var spacing = 16;
    var legal_x = 32;
    var legal_y = home_row_y + 32;
    var legal_width = ui_legal_width();
    var col_width = legal_width / 2 - spacing * 1.5;
    var col2_x = legal_x + col_width + spacing * 2;
    
    var vx1 = col_width / 2;
    var vy1 = 0;
    var vx2 = col_width;
    var vy2 = vy1 + 24;
    
    var button_width = 128;
    
    #region tab: general
    var yy = legal_y + spacing;
    
    element = create_text(legal_x + spacing, yy, "General Settings", col_width, element_height, fa_left, col_width, t_general);
    element.color = c_blue;
    ds_list_add(t_general.contents, element);
    
    yy += element.height + spacing;
    
    element = create_text(legal_x + spacing, yy, "Width: " + string(mode.width), col_width, element_height, fa_left, col_width, t_general);
    t_general.element_width = element;
    ds_list_add(t_general.contents, element);
    
    yy += element.height + spacing;
    
    element = create_text(legal_x + spacing, yy, "Height: " + string(mode.height), col_width, element_height, fa_left, col_width, t_general);
    t_general.element_height = element;
    ds_list_add(t_general.contents, element);
    
    yy += element.height + spacing;
    
    element = create_checkbox(legal_x + spacing, yy, "Orthographic?", col_width, element_height, ui_input_terrain_orthographic, mode.orthographic, t_general);
    element.tooltip = "View the terrain from 2D top-down perspective, as opposed to a 3D one";
    ds_list_add(t_general.contents, element);
    
    yy += element.height + spacing;
    
    element = create_checkbox(legal_x + spacing, yy, "Draw water?", col_width, element_height, ui_input_terrain_draw_water, mode.view_water, t_general);
    element.tooltip = "Toggles the the water layer under the terrain";
    t_general.element_draw_water = element;
    ds_list_add(t_general.contents, element);
    
    yy += element.height + spacing;
    
    element = create_checkbox(legal_x + spacing, yy, "Smooth shading?", col_width, element_height, ui_input_terrain_smooth_shading, mode.smooth_shading, t_general);
    element.tooltip = "Toggles smooth vs flat shading on the terrain";
    t_general.element_smooth_shading = element;
    //ds_list_add(t_general.contents, element);
    
    //yy += element.height + spacing;
    
    element = create_text(legal_x + spacing, yy, "Editor Settings", col_width, element_height, fa_left, col_width, t_general);
    element.color = c_blue;
    ds_list_add(t_general.contents, element);
    
    yy += element.height + spacing;
    
    element = create_radio_array(legal_x + spacing, yy, "Mode:", col_width, element_height, ui_input_terrain_set_mode, mode.mode, t_general);
    element.tooltip = "Edit the terrain's shape, texture or color. You may also set the mode by clicking the button at the top of each of the respective tabs.";
    create_radio_array_options(element, ["Deform", "Texture", "Paint"]);
    t_general.element_mode = element;
    ds_list_add(t_general.contents, element);
    
    yy += ui_get_radio_array_height(element) + spacing;
    
    element = create_radio_array(legal_x + spacing, yy, "Brush shape:", col_width, element_height, ui_input_terrain_set_brush_shape, mode.style, t_general);
    element.tooltip = "In case you want to use a different shape to edit terrain.";
    create_radio_array_options(element, ["Block", "Circle"]);
    t_general.element_brush_shape = element;
    ds_list_add(t_general.contents, element);
    
    yy += ui_get_radio_array_height(element) + spacing;
    
    element = create_text(legal_x + spacing, yy, "Brush radius: " + string(mode.radius) + " cells", col_width, element_height, fa_left, col_width, t_general);
    t_general.element_brush_radius = element;
    ds_list_add(t_general.contents, element);
    
    yy += element.height + spacing;
    
    element = create_progress_bar(legal_x + spacing, yy, col_width, element_height, ui_input_terrain_set_brush_radius, 4, normalize_correct(mode.radius, 0, 1, mode.brush_min, mode.brush_max), t_general);
    element.tooltip = "A larger brush will allow you to edit more terrain at once, and a smaller one will give you more precision.";
    t_general.element_brush_radius_bar = element;
    ds_list_add(t_general.contents, element);
    
    yy += element.height + spacing;
    
    // second column
    
    yy = legal_y + spacing;
    
    element = create_text(col2_x, yy, "Exporting Terrain", col_width, element_height, fa_left, col_width, t_general);
    element.color = c_blue;
    ds_list_add(t_general.contents, element);
    
    yy += element.height + spacing;
    
    element = create_button(col2_x, yy, "New Terrain", col_width, element_height, fa_center, ui_terrain_new, t_general);
    ds_list_add(t_general.contents, element);
    
    yy += element.height + spacing;
    
    element = create_button(col2_x, yy, "Save Terrain", col_width, element_height, fa_center, uivc_terrain_save, t_general);
    ds_list_add(t_general.contents, element);
    
    yy += element.height + spacing;
    
    element = create_button(col2_x, yy, "Load Terrain", col_width, element_height, fa_center, uivc_terrain_load, t_general);
    ds_list_add(t_general.contents, element);
    
    yy += element.height + spacing;
    
    element = create_button(col2_x, yy, "Export Terrain", col_width, element_height, fa_center, uivc_terrain_export, t_general);
    ds_list_add(t_general.contents, element);
    
    yy += element.height + spacing;
    
    element = create_input(col2_x, yy, "Export scale:", col_width, element_height, ui_input_terrain_save_scale, mode.save_scale, "0.01...100", validate_double, 0.01, 100, 4, vx1 + 32, vy1, vx2, vy2, t_general);
    element.tooltip = "If you want to export final models with a different scale, use this option.";
    t_general.element_save_scale = element;
    ds_list_add(t_general.contents, element);
    
    yy += element.height + spacing;
    
    element = create_checkbox(col2_x, yy, "Export: all faces?", col_width, element_height, ui_input_terrain_export_all, mode.export_all, t_general);
    element.tooltip = "Most of the time you probably only want to export triangles that aren't flat on the ground, but you can force it to export all of them instead. Note: this will produce very large files and will take quite a lot longer to process, for obvious reasons.";
    t_general.element_save_all_faces = element;
    ds_list_add(t_general.contents, element);
    
    yy += element.height + spacing;
    
    element = create_checkbox(col2_x, yy, "OBJ: use Y up?", col_width, element_height, ui_input_terrain_export_swap_zup, mode.export_swap_zup, t_general);
    element.tooltip = "Some 3D model programs (cough cough, Blender) use the +Y axis as the Up vector by default.";
    t_general.element_swap_zup = element;
    ds_list_add(t_general.contents, element);
    
    yy += element.height + spacing;
    
    element = create_checkbox(col2_x, yy, "OBJ: swap UVs?", col_width, element_height, ui_input_terrain_export_swap_uvs, mode.export_swap_uvs, t_general);
    element.tooltip = "Game Maker maps UV coordinates upside-down, compared to some 3D model programs. Use this option to convert to that.";
    t_general.element_swap_uvs = element;
    ds_list_add(t_general.contents, element);
    
    yy += element.height + spacing;
    
    element = create_button(col2_x, yy, "Import Heightmap", col_width, element_height, fa_center, ui_terrain_new, t_general);
    ds_list_add(t_general.contents, element);
    
    yy += element.height + spacing;
    
    element = create_button(col2_x, yy, "Export Heightmap", col_width, element_height, fa_center, uivc_terrain_export_heightmap, t_general);
    ds_list_add(t_general.contents, element);
    
    yy += element.height + spacing;
    
    element = create_text(col2_x, yy, "DDD Stuff", col_width, element_height, fa_left, col_width, t_general);
    element.color = c_blue;
    ds_list_add(t_general.contents, element);
    
    yy += element.height + spacing;
    
    element = create_button(col2_x, yy, "Add to Project", col_width, element_height, fa_center, null, t_general);
    element.interactive = false;
    ds_list_add(t_general.contents, element);
    
    yy += element.height + spacing;
    
    #endregion
    
    #region tab: lights
    
    yy = legal_y + spacing;
    
    element = create_checkbox(legal_x + spacing, yy, "Light enabled?", col_width, element_height, ui_checkbox_light_enabled, mode.terrain_light_enabled, t_lighting);
    ds_list_add(t_lighting.contents, element);
    yy += element.height + spacing;
    
    element = create_color_picker(legal_x + spacing, yy, "Ambient:", col_width, element_height, ui_checkbox_light_ambient, mode.terrain_light_ambient, vx1, vy1, vx2, vy2, t_lighting);
    ds_list_add(t_lighting.contents, element);
    yy += element.height + spacing;
    
    element = create_list(legal_x + spacing, yy, "Terrain Lights", "", col_width, element_height, MAX_TERRAIN_LIGHTS, uivc_terrain_light_select, false, t_lighting, mode.lights);
    element.allow_deselect = false;
    element.entries_are = ListEntries.INSTANCES;
    ui_list_select(element, 0);
    ds_list_add(t_lighting.contents, element);
    t_lighting.el_light_list = element;
    yy += ui_get_list_height(element) + spacing;
    
    element = create_checkbox(legal_x + spacing, yy, "Fog enabled?", col_width, element_height, ui_checkbox_fog_enabled, mode.terrain_fog_enabled, t_lighting);
    ds_list_add(t_lighting.contents, element);
    yy += element.height + spacing;
    
    element = create_color_picker(legal_x + spacing, yy, "Fog color:", col_width, element_height, ui_checkbox_fog_color, mode.terrain_fog_color, vx1, vy1, vx2, vy2, t_lighting);
    ds_list_add(t_lighting.contents, element);
    yy += element.height + spacing;
    
    element = create_input(legal_x + spacing, yy, "Start:", col_width, element_height, ui_checkbox_fog_start, mode.terrain_fog_start, "number", validate_double, -100000, 100000, 8, vx1, vy1, vx2, vy2, t_lighting);
    ds_list_add(t_lighting.contents, element);
    yy += element.height + spacing;
    
    element = create_input(legal_x + spacing, yy, "End:", col_width, element_height, ui_checkbox_fog_end, mode.terrain_fog_end, "number", validate_double, -100000, 100000, 8, vx1, vy1, vx2, vy2, t_lighting);
    ds_list_add(t_lighting.contents, element);
    yy += element.height + spacing;
    
    yy = legal_y + spacing;
    
    element = create_text(col2_x, yy, "Light Properties", col_width, element_height, fa_left, col_width, t_lighting);
    ds_list_add(t_lighting.contents, element);
    yy += element.height + spacing;
    
    element = create_radio_array(col2_x, yy, "Type", col_width, element_height, ui_radio_terrain_light_type, 0, t_lighting);
    create_radio_array_options(element, ["None", "Direction", "Point", "Spot"]);
    element.contents[| 2].enabled = false;
    ds_list_add(t_lighting.contents, element);
    t_lighting.el_light_type = element;
    yy += ui_get_radio_array_height(element) + spacing;
    
    element = create_color_picker(col2_x, yy, "Color:", col_width, element_height, ui_color_terrain_light_color, c_white, vx1, vy1, vx2, vy2, t_lighting);
    ds_list_add(t_lighting.contents, element);
    t_lighting.el_light_color = element;
    yy += element.height + spacing;
    
    // directional light
    
    var yy_base = yy;
    
    element = create_text(col2_x, yy, "X:", col_width, element_height, fa_left, col_width, t_lighting);
    element.enabled = false;
    ds_list_add(t_lighting.contents, element);
    yy += element.height + spacing;
    
    element = create_progress_bar(col2_x, yy, col_width, element_height, ui_input_terrain_light_dir_x, 4, 0.5, t_lighting);
    element.enabled = false;
    ds_list_add(t_lighting.contents, element);
    t_lighting.el_dir_x = element;
    yy += element.height + spacing;
    
    element = create_text(col2_x, yy, "Y:", col_width, element_height, fa_left, col_width, t_lighting);
    element.enabled = false;
    ds_list_add(t_lighting.contents, element);
    yy += element.height + spacing;
    
    element = create_progress_bar(col2_x, yy, col_width, element_height, ui_input_terrain_light_dir_y, 4, 0.5, t_lighting);
    element.enabled = false;
    ds_list_add(t_lighting.contents, element);
    t_lighting.el_dir_y = element;
    yy += element.height + spacing;
    
    element = create_text(col2_x, yy, "Z:", col_width, element_height, fa_left, col_width, t_lighting);
    element.enabled = false;
    ds_list_add(t_lighting.contents, element);
    yy += element.height + spacing;
    
    element = create_progress_bar(col2_x, yy, col_width, element_height, ui_input_terrain_light_dir_z, 4, 0.5, t_lighting);
    element.enabled = false;
    ds_list_add(t_lighting.contents, element);
    t_lighting.el_dir_z = element;
    yy += element.height + spacing;
    
    // point light
    
    yy = yy_base;
    
    element = create_input(col2_x, yy, "X:", col_width, element_height, ui_input_terrain_light_point_x, 0, "number", validate_double, -1000, 100000, 8, vx1, vy1, vx2, vy2, t_lighting);
    element.enabled = false;
    ds_list_add(t_lighting.contents, element);
    t_lighting.el_point_x = element;
    yy += element.height + spacing;
    
    element = create_input(col2_x, yy, "Y:", col_width, element_height, ui_input_terrain_light_point_y, 0, "number", validate_double, -1000, 100000, 8, vx1, vy1, vx2, vy2, t_lighting);
    element.enabled = false;
    ds_list_add(t_lighting.contents, element);
    t_lighting.el_point_y = element;
    yy += element.height + spacing;
    
    element = create_input(col2_x, yy, "Z:", col_width, element_height, ui_input_terrain_light_point_z, 0, "number", validate_double, -1000, 100000, 8, vx1, vy1, vx2, vy2, t_lighting);
    element.enabled = false;
    ds_list_add(t_lighting.contents, element);
    t_lighting.el_point_z = element;
    yy += element.height + spacing;
    
    element = create_input(col2_x, yy, "Radius:", col_width, element_height, ui_input_terrain_light_point_radius, 0, "number", validate_double, 0, 100000, 8, vx1, vy1, vx2, vy2, t_lighting);
    element.enabled = false;
    ds_list_add(t_lighting.contents, element);
    t_lighting.el_point_radius = element;
    yy += element.height + spacing;
    
    #endregion
    
    #region tab: deform
    var yy = legal_y + spacing;
    
    element = create_button(legal_x + spacing, yy, "Set Mode: Deform", col_width, element_height, fa_center, uivc_terrain_set_mode_heightmap, t_general);
    ds_list_add(t_heightmap.contents, element);
    
    yy += element.height + spacing;
    
    element = create_button(legal_x + spacing, yy, "Reset Height", col_width, element_height, fa_center, uivc_terrain_reset_z, t_general);
    ds_list_add(t_heightmap.contents, element);
    
    yy += element.height + spacing;
    
    element = create_radio_array(legal_x + spacing, yy, "Deformation mode:", col_width, element_height, ui_input_terrain_set_deform_mode, mode.submode, t_heightmap);
    element.tooltip = "The method which you would like to use to mold the terrain.";
    create_radio_array_options(element, ["Mound", "Average", "Flat Average", "Zero (Erase)"]);
    t_heightmap.element_deform_mode = element;
    ds_list_add(t_heightmap.contents, element);
    
    yy += ui_get_radio_array_height(element) + spacing;
    
    element = create_text(legal_x + spacing, yy, "Deformation rate: " + string_format(mode.rate, 1, 3), col_width, element_height, fa_left, col_width, t_heightmap);
    t_heightmap.element_deform_rate = element;
    ds_list_add(t_heightmap.contents, element);
    
    yy += element.height + spacing;
    
    element = create_progress_bar(legal_x + spacing, yy, col_width, element_height, ui_input_terrain_set_deformation_rate, 4, normalize_correct(mode.rate, 0, 1, mode.rate_min, mode.rate_max), t_heightmap);
    element.tooltip = "A smaller rate will give you more precision, and a larger rate will make the deformation more dramatic.";
    t_heightmap.element_deform_rate_bar = element;
    ds_list_add(t_heightmap.contents, element);
    
    yy += element.height + spacing;
    
    #endregion
    
    #region tab: texture
    var yy = legal_y + spacing;
    
    element = create_button(legal_x + spacing, yy, "Set Mode: Texture", col_width, element_height, fa_center, uivc_terrain_set_mode_texture, t_general);
    ds_list_add(t_texture.contents, element);
    
    yy += element.height + spacing;
    
    element = create_button(legal_x + spacing, yy, "Save Texture", col_width, element_height, fa_center, uivc_terrain_export_texture, t_texture);
    ds_list_add(t_texture.contents, element);
    
    element = create_button(col2_x, yy, "Change Texture", col_width, element_height, fa_center, uivc_terrain_change_texture, t_texture);
    ds_list_add(t_texture.contents, element);
    
    yy += element.height + spacing;
    
    element = create_text(legal_x + spacing, yy, mode.texture_name + " (" + string(mode.texture_width) + " x " + string(mode.texture_height) + ")", legal_width, element_height, fa_left, legal_width, t_texture);
    t_texture.element_texture_name = element;
    ds_list_add(t_texture.contents, element);
    
    yy += element.height + spacing;
    
    element = create_tile_selector(legal_x + spacing, yy, legal_width - spacing * 2, legal_width - spacing * 2, uivc_select_terrain_tile, null, t_texture);
    element.tile_x = mode.tile_brush_x;
    element.tile_y = mode.tile_brush_y;
    element.tileset = mode.texture;
    t_texture.element_tile_selector = element;
    ds_list_add(t_texture.contents, element);
    
    yy += element.height + spacing;
    
    var yy_aftergrid = yy;
    
    element = create_button(legal_x + spacing, yy, "Clear Texture", col_width, element_height, fa_center, uivc_terrain_clear_texture, t_general);
    ds_list_add(t_texture.contents, element);
    
    yy += element.height + spacing;
    
    #endregion
    
    #region tab: painting
    var yy = legal_y + spacing;
    
    element = create_button(legal_x + spacing, yy, "Set Mode: Paint", col_width, element_height, fa_center, uivc_terrain_set_mode_paint, t_general);
    ds_list_add(t_paint.contents, element);
    
    yy += element.height + spacing;
    
    element = create_text(legal_x + spacing, yy, "Paint strength: " + string(mode.paint_strength), col_width, element_height, fa_left, col_width, t_paint);
    t_paint.element_paint_strength = element;
    ds_list_add(t_paint.contents, element);
    
    yy += element.height + spacing;
    
    element = create_progress_bar(legal_x + spacing, yy, col_width, element_height, ui_input_terrain_set_paint_strength, 4, normalize_correct(mode.paint_strength, 0, 1, mode.paint_strength_min, mode.paint_strength_max), t_paint);
    element.tooltip = "A lower strength value will cause the color to blend with the existing color, and a greater one will cause it to replace the existing color.";
    t_paint.element_paint_strength_bar = element;
    ds_list_add(t_paint.contents, element);
    
    yy += element.height + spacing;
    
    element = create_color_picker(legal_x + spacing, yy, "Color:", col_width, element_height, ui_input_terrain_set_paint_color, mode.paint_color, vx1, vy1, vx2, vy2, t_paint);
    element.tooltip = "I really hope you enjoy this color picker because it was probably my favorite UI element to work on.";
    element.allow_alpha = true;
    t_paint.element_paint_color = element;
    ds_list_add(t_paint.contents, element);
    
    yy += element.height + spacing;
    
    element = create_button(legal_x + spacing, yy, "Clear Color", col_width, element_height, fa_center, uivc_terrain_clear_color, t_general);
    ds_list_add(t_paint.contents, element);
    
    yy += element.height + spacing;
    
    #endregion
    
    return id;
}