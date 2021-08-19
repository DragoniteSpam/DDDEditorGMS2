function ui_init_terrain(mode) {
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
        var legal_width = self.GetLegalWidth();
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
        
        element = create_checkbox(legal_x + spacing, yy, "Orthographic?", col_width, element_height, function(checkbox) {
            Stuff.terrain.orthographic = checkbox.value;
        }, mode.orthographic, t_general);
        element.tooltip = "View the terrain from 2D top-down perspective, as opposed to a 3D one";
        ds_list_add(t_general.contents, element);
        
        yy += element.height + spacing;
        
        element = create_checkbox(legal_x + spacing, yy, "Draw water?", col_width, element_height, function(checkbox) {
            Stuff.terrain.view_water = checkbox.value;
        }, mode.view_water, t_general);
        element.tooltip = "Toggles the the water layer under the terrain";
        t_general.element_draw_water = element;
        ds_list_add(t_general.contents, element);
        
        yy += element.height + spacing;
        
        element = create_checkbox(legal_x + spacing, yy, "Smooth shading?", col_width, element_height, function(checkbox) {
            Stuff.terrain.smooth_shading = checkbox.value;
        }, mode.smooth_shading, t_general);
        element.tooltip = "Toggles smooth vs flat shading on the terrain";
        t_general.element_smooth_shading = element;
        //ds_list_add(t_general.contents, element);
        
        //yy += element.height + spacing;
        element = create_text(legal_x + spacing, yy, "Editor Settings", col_width, element_height, fa_left, col_width, t_general);
        element.color = c_blue;
        ds_list_add(t_general.contents, element);
        
        yy += element.height + spacing;
        
        element = create_radio_array(legal_x + spacing, yy, "Mode:", col_width, element_height, function(option) {
            Stuff.terrain.mode = option.root.value;
        }, mode.mode, t_general);
        element.tooltip = "Edit the terrain's shape, texture or color. You may also set the mode by clicking the button at the top of each of the respective tabs.";
        create_radio_array_options(element, ["Deform", "Texture", "Paint"]);
        t_general.element_mode = element;
        ds_list_add(t_general.contents, element);
        
        yy += element.GetHeight() + spacing;
        
        element = create_radio_array(legal_x + spacing, yy, "Brush shape:", col_width, element_height, function(option) {
            Stuff.terrain.style = option.root.value;
        }, mode.style, t_general);
        element.tooltip = "In case you want to use a different shape to edit terrain.";
        create_radio_array_options(element, ["Block", "Circle"]);
        t_general.element_brush_shape = element;
        ds_list_add(t_general.contents, element);
        
        yy += element.GetHeight() + spacing;
        
        element = create_text(legal_x + spacing, yy, "Brush radius: " + string(mode.radius) + " cells", col_width, element_height, fa_left, col_width, t_general);
        t_general.element_brush_radius = element;
        ds_list_add(t_general.contents, element);
        
        yy += element.height + spacing;
        
        element = create_progress_bar(legal_x + spacing, yy, col_width, element_height, function(bar) {
            Stuff.terrain.radius = normalize(bar.value, Stuff.terrain.brush_min, Stuff.terrain.brush_max, 0, 1);
            bar.root.element_brush_radius.text = "Brush radius: " + string(Stuff.terrain.radius) + " cells";
        }, 4, normalize(mode.radius, 0, 1, mode.brush_min, mode.brush_max), t_general);
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
        
        element = create_button(col2_x, yy, "New Terrain", col_width, element_height, fa_center, function(button) {
            dialog_create_terrain_new(undefined);
        }, t_general);
        ds_list_add(t_general.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(col2_x, yy, "Save Terrain", col_width, element_height, fa_center, function(button) {
            var fn = get_save_filename_terrain("terrain");
            if (fn != "") {
                terrain_save(fn);
            }
        }, t_general);
        ds_list_add(t_general.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(col2_x, yy, "Load Terrain", col_width, element_height, fa_center, function(button) {
            var fn = get_open_filename_terrain();
            if (fn != "") {
                terrain_load(fn);
            }
        }, t_general);
        ds_list_add(t_general.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(col2_x, yy, "Export Terrain", col_width, element_height, fa_center, function(button) {
            var fn = get_save_filename_mesh("terrain");
            if (fn != "") {
                switch (filename_ext(fn)) {
                    case ".d3d": case ".gmmod": terrain_save_d3d(fn); break;
                    case ".obj": terrain_save_obj(fn); break;
                }
            }
        }, t_general);
        ds_list_add(t_general.contents, element);
        
        yy += element.height + spacing;
        
        element = create_input(col2_x, yy, "Export scale:", col_width, element_height, function(input) {
            Stuff.terrain.save_scale = real(input.value);
        }, mode.save_scale, "0.01...100", validate_double, 0.01, 100, 4, vx1 + 32, vy1, vx2, vy2, t_general);
        element.tooltip = "If you want to export final models with a different scale, use this option.";
        t_general.element_save_scale = element;
        ds_list_add(t_general.contents, element);
        
        yy += element.height + spacing;
        
        element = create_checkbox(col2_x, yy, "Export: all faces?", col_width, element_height, function(checkbox) {
            Stuff.terrain.export_all = checkbox.value;
        }, mode.export_all, t_general);
        element.tooltip = "Most of the time you probably only want to export triangles that aren't flat on the ground, but you can force it to export all of them instead. Note: this will produce very large files and will take quite a lot longer to process, for obvious reasons.";
        t_general.element_save_all_faces = element;
        ds_list_add(t_general.contents, element);
        
        yy += element.height + spacing;
        
        element = create_checkbox(col2_x, yy, "OBJ: use Y up?", col_width, element_height, function(checkbox) {
            Stuff.terrain.export_swap_zup= checkbox.value;
        }, mode.export_swap_zup, t_general);
        element.tooltip = "Some 3D model programs (cough cough, Blender) use the +Y axis as the Up vector by default.";
        t_general.element_swap_zup = element;
        ds_list_add(t_general.contents, element);
        
        yy += element.height + spacing;
        
        element = create_checkbox(col2_x, yy, "OBJ: swap UVs?", col_width, element_height, function(checkbox) {
            Stuff.terrain.export_swap_uvs = checkbox.value;
        }, mode.export_swap_uvs, t_general);
        element.tooltip = "Game Maker maps UV coordinates upside-down, compared to some 3D model programs. Use this option to convert to that.";
        t_general.element_swap_uvs = element;
        ds_list_add(t_general.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(col2_x, yy, "Import Heightmap", col_width, element_height, fa_center, function(button) {
            dialog_create_terrain_new(undefined);
        }, t_general);
        ds_list_add(t_general.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(col2_x, yy, "Export Heightmap", col_width, element_height, fa_center, function(button) {
            var fn = get_save_filename_image("heightmap");
            if (fn != "") {
                dialog_create_export_heightmap(button.root).filename = fn;
            }
        }, t_general);
        ds_list_add(t_general.contents, element);
        
        yy += element.height + spacing;
        
        element = create_text(col2_x, yy, "DDD Stuff", col_width, element_height, fa_left, col_width, t_general);
        element.color = c_blue;
        ds_list_add(t_general.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(col2_x, yy, "Add to Project", col_width, element_height, fa_center, function(button) {
            terrain_add_to_project();
        }, t_general);
        ds_list_add(t_general.contents, element);
        
        yy += element.height + spacing;
        #endregion
        
        #region tab: lights
        yy = legal_y + spacing;
        
        element = create_checkbox(legal_x + spacing, yy, "Light enabled?", col_width, element_height, function(checkbox) {
            Stuff.terrain.terrain_light_enabled = checkbox.value;
        }, mode.terrain_light_enabled, t_lighting);
        ds_list_add(t_lighting.contents, element);
        yy += element.height + spacing;
        
        element = create_color_picker(legal_x + spacing, yy, "Ambient:", col_width, element_height, function(picker) {
            Stuff.terrain.terrain_light_ambient = picker.value;
        }, mode.terrain_light_ambient, vx1, vy1, vx2, vy2, t_lighting);
        ds_list_add(t_lighting.contents, element);
        yy += element.height + spacing;
        
        element = create_list(legal_x + spacing, yy, "Terrain Lights", "", col_width, element_height, MAX_TERRAIN_LIGHTS, function(list) {
            var mode = Stuff.terrain;
            var tab = mode.ui.t_lighting;
            
            var light = mode.lights[ui_list_selection(list)];
            tab.el_light_type.value = light.type;
            tab.el_light_color.value = light.color;
            
            switch (light.type) {
                case LightTypes.DIRECTIONAL:
                    tab.el_dir_x.value = normalize(light.x, 0, 1, -0.5, 0.5);
                    tab.el_dir_y.value = normalize(light.y, 0, 1, -0.5, 0.5);
                    tab.el_dir_z.value = normalize(light.z, 0, 1, -0.5, 0.5);
                    break;
                case LightTypes.POINT:
                    ui_input_set_value(tab.el_point_x, light.x);
                    ui_input_set_value(tab.el_point_y, light.y);
                    ui_input_set_value(tab.el_point_z, light.z);
                    ui_input_set_value(tab.el_point_radius, light.radius);
                    break;
            }
            
            uivc_terrain_light_enable_by_type(list);
        }, false, t_lighting, mode.lights);
        element.allow_deselect = false;
        element.entries_are = ListEntries.SCRIPT;
        element.render_colors = function(list, index) {
            var light = list.entries[index];
            return (light.type == LightTypes.SPOT || light.type == LightTypes.NONE) ? c_gray : c_black;
        };
        element.evaluate_text = function(list, index) {
            var light = list.entries[index];
            switch (light.type) {
                case LightTypes.NONE:
                    return "<disabled light>";
                case LightTypes.POINT:
                    return "Point @ " + string(light.x) + "," + string(light.y) + "," + string(light.z) + " r: " + string(light.radius);
                case LightTypes.DIRECTIONAL:
                    return "Directional @ " + string(light.x) + "," + string(light.y) + "," + string(light.z);
                case LightTypes.SPOT:
                    return "Spot @ " + string(light.x) + "," + string(light.y) + "," + string(light.z) + " r: " + string(light.radius);
            }
            return "*";
        };
        ui_list_select(element, 0);
        ds_list_add(t_lighting.contents, element);
        t_lighting.el_light_list = element;
        yy += element.GetHeight() + spacing;
        
        element = create_checkbox(legal_x + spacing, yy, "Fog enabled?", col_width, element_height, function(checkbox) {
            Stuff.terrain.terrain_fog_enabled = checkbox.value;
        }, mode.terrain_fog_enabled, t_lighting);
        ds_list_add(t_lighting.contents, element);
        yy += element.height + spacing;
        
        element = create_color_picker(legal_x + spacing, yy, "Fog color:", col_width, element_height, function(picker) {
            Stuff.terrain.terrain_fog_color = picker.value;
        }, mode.terrain_fog_color, vx1, vy1, vx2, vy2, t_lighting);
        ds_list_add(t_lighting.contents, element);
        yy += element.height + spacing;
        
        element = create_input(legal_x + spacing, yy, "Start:", col_width, element_height, function(input) {
            Stuff.terrain.terrain_fog_start = real(input.value);
        }, mode.terrain_fog_start, "number", validate_double, -100000, 100000, 8, vx1, vy1, vx2, vy2, t_lighting);
        ds_list_add(t_lighting.contents, element);
        yy += element.height + spacing;
        
        element = create_input(legal_x + spacing, yy, "End:", col_width, element_height, function(input) {
            Stuff.terrain.terrain_fog_end = real(input.value);
        }, mode.terrain_fog_end, "number", validate_double, -100000, 100000, 8, vx1, vy1, vx2, vy2, t_lighting);
        ds_list_add(t_lighting.contents, element);
        yy += element.height + spacing;
        
        yy = legal_y + spacing;
        
        element = create_text(col2_x, yy, "Light Properties", col_width, element_height, fa_left, col_width, t_lighting);
        ds_list_add(t_lighting.contents, element);
        yy += element.height + spacing;
        
        element = create_radio_array(col2_x, yy, "Type", col_width, element_height, function(radio) {
            Stuff.terrain.lights[ui_list_selection(radio.root.root.el_light_list)].type = radio.value;
            uivc_terrain_light_enable_by_type(radio.root.root.el_light_list);
        }, 0, t_lighting);
        create_radio_array_options(element, ["None", "Direction", "Point", "Spot"]);
        element.contents[| 2].enabled = false;
        ds_list_add(t_lighting.contents, element);
        t_lighting.el_light_type = element;
        yy += element.GetHeight() + spacing;
        
        element = create_color_picker(col2_x, yy, "Color:", col_width, element_height, function(picker) {
            Stuff.terrain.lights[ui_list_selection(color.root.el_light_list)].color = color.value;
        }, c_white, vx1, vy1, vx2, vy2, t_lighting);
        ds_list_add(t_lighting.contents, element);
        t_lighting.el_light_color = element;
        yy += element.height + spacing;
        
        // directional light
        var yy_base = yy;
        
        element = create_text(col2_x, yy, "X component:", col_width, element_height, fa_left, col_width, t_lighting);
        element.enabled = false;
        ds_list_add(t_lighting.contents, element);
        t_lighting.el_dir_x_name = element;
        yy += element.height + spacing;
        
        element = create_progress_bar(col2_x, yy, col_width, element_height, function(bar) {
            var light = Stuff.terrain.lights[ui_list_selection(bar.root.el_light_list)];
            light.x = bar.value * 2 - 1;
            if (light.x == 0 && light.y == 0 && light.z == 0) {
                light.z = -1;
            }
        }, 4, 0.5, t_lighting);
        element.enabled = false;
        ds_list_add(t_lighting.contents, element);
        t_lighting.el_dir_x = element;
        yy += element.height + spacing;
        
        element = create_text(col2_x, yy, "Y component:", col_width, element_height, fa_left, col_width, t_lighting);
        element.enabled = false;
        ds_list_add(t_lighting.contents, element);
        t_lighting.el_dir_y_name = element;
        yy += element.height + spacing;
        
        element = create_progress_bar(col2_x, yy, col_width, element_height, function(bar) {
            var light = Stuff.terrain.lights[ui_list_selection(bar.root.el_light_list)];
            light.y = bar.value * 2 - 1;
            if (light.x == 0 && light.y == 0 && light.z == 0) {
                light.z = -1;
            }
        }, 4, 0.5, t_lighting);
        element.enabled = false;
        ds_list_add(t_lighting.contents, element);
        t_lighting.el_dir_y = element;
        yy += element.height + spacing;
        
        element = create_text(col2_x, yy, "Z component:", col_width, element_height, fa_left, col_width, t_lighting);
        element.enabled = false;
        ds_list_add(t_lighting.contents, element);
        t_lighting.el_dir_z_name = element;
        yy += element.height + spacing;
        
        element = create_progress_bar(col2_x, yy, col_width, element_height, function(bar) {
            var light = Stuff.terrain.lights[ui_list_selection(bar.root.el_light_list)];
            light.z = bar.value * 2 - 1;
        
            if (light.x == 0 && light.y == 0 && light.z == 0) {
                light.z = -1;
            }
        }, 4, 0.5, t_lighting);
        element.enabled = false;
        ds_list_add(t_lighting.contents, element);
        t_lighting.el_dir_z = element;
        yy += element.height + spacing;
        
        // point light
        yy = yy_base;
        
        element = create_input(col2_x, yy, "X:", col_width, element_height, function(input) {
            Stuff.terrain.lights[ui_list_selection(input.root.el_light_list)].x = real(input.value);
        }, 0, "number", validate_double, -1000, 100000, 8, vx1, vy1, vx2, vy2, t_lighting);
        element.enabled = false;
        ds_list_add(t_lighting.contents, element);
        t_lighting.el_point_x = element;
        yy += element.height + spacing;
        
        element = create_input(col2_x, yy, "Y:", col_width, element_height, function(input) {
            Stuff.terrain.lights[ui_list_selection(input.root.el_light_list)].y = real(input.value);
        }, 0, "number", validate_double, -1000, 100000, 8, vx1, vy1, vx2, vy2, t_lighting);
        element.enabled = false;
        ds_list_add(t_lighting.contents, element);
        t_lighting.el_point_y = element;
        yy += element.height + spacing;
        
        element = create_input(col2_x, yy, "Z:", col_width, element_height, function(input) {
            Stuff.terrain.lights[ui_list_selection(input.root.el_light_list)].z = real(input.value);
        }, 0, "number", validate_double, -1000, 100000, 8, vx1, vy1, vx2, vy2, t_lighting);
        element.enabled = false;
        ds_list_add(t_lighting.contents, element);
        t_lighting.el_point_z = element;
        yy += element.height + spacing;
        
        element = create_input(col2_x, yy, "Radius:", col_width, element_height, function(input) {
            Stuff.terrain.lights[ui_list_selection(input.root.el_light_list)].radius = real(input.value);
        }, 0, "number", validate_double, 0, 100000, 8, vx1, vy1, vx2, vy2, t_lighting);
        element.enabled = false;
        ds_list_add(t_lighting.contents, element);
        t_lighting.el_point_radius = element;
        yy += element.height + spacing;
        #endregion
        
        #region tab: deform
        yy = legal_y + spacing;
        
        element = create_button(legal_x + spacing, yy, "Set Mode: Deform", col_width, element_height, fa_center, function(button) {
            button.root.root.t_general.element_mode.value = TerrainModes.Z;
            Stuff.terrain.mode = TerrainModes.Z;
        }, t_general);
        ds_list_add(t_heightmap.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(legal_x + spacing, yy, "Reset Height", col_width, element_height, fa_center, function(button) {
            var terrain = Stuff.terrain;
            buffer_fill(terrain.height_data, 0, buffer_f32, 0, buffer_get_size(terrain.height_data));
            
            for (var i = 0; i < terrain.width - 1; i++) {
                for (var j = 0; j < terrain.height - 1; j++) {
                    var index0 = terrain_get_vertex_index(terrain, i, j, 0);
                    var index1 = index0 + VERTEX_SIZE;
                    var index2 = index1 + VERTEX_SIZE;
                    var index3 = index2 + VERTEX_SIZE;
                    var index4 = index3 + VERTEX_SIZE;
                    var index5 = index4 + VERTEX_SIZE;
                    
                    buffer_poke(terrain.terrain_buffer_data, index0 + 8, buffer_f32, 0);
                    buffer_poke(terrain.terrain_buffer_data, index1 + 8, buffer_f32, 0);
                    buffer_poke(terrain.terrain_buffer_data, index2 + 8, buffer_f32, 0);
                    buffer_poke(terrain.terrain_buffer_data, index3 + 8, buffer_f32, 0);
                    buffer_poke(terrain.terrain_buffer_data, index4 + 8, buffer_f32, 0);
                    buffer_poke(terrain.terrain_buffer_data, index5 + 8, buffer_f32, 0);
                    buffer_poke(terrain.terrain_buffer_data, index0 + 12, buffer_f32, 0);
                    buffer_poke(terrain.terrain_buffer_data, index1 + 12, buffer_f32, 0);
                    buffer_poke(terrain.terrain_buffer_data, index2 + 12, buffer_f32, 0);
                    buffer_poke(terrain.terrain_buffer_data, index3 + 12, buffer_f32, 0);
                    buffer_poke(terrain.terrain_buffer_data, index4 + 12, buffer_f32, 0);
                    buffer_poke(terrain.terrain_buffer_data, index5 + 12, buffer_f32, 0);
                    buffer_poke(terrain.terrain_buffer_data, index0 + 16, buffer_f32, 0);
                    buffer_poke(terrain.terrain_buffer_data, index1 + 16, buffer_f32, 0);
                    buffer_poke(terrain.terrain_buffer_data, index2 + 16, buffer_f32, 0);
                    buffer_poke(terrain.terrain_buffer_data, index3 + 16, buffer_f32, 0);
                    buffer_poke(terrain.terrain_buffer_data, index4 + 16, buffer_f32, 0);
                    buffer_poke(terrain.terrain_buffer_data, index5 + 16, buffer_f32, 0);
                    buffer_poke(terrain.terrain_buffer_data, index0 + 20, buffer_f32, 1);
                    buffer_poke(terrain.terrain_buffer_data, index1 + 20, buffer_f32, 1);
                    buffer_poke(terrain.terrain_buffer_data, index2 + 20, buffer_f32, 1);
                    buffer_poke(terrain.terrain_buffer_data, index3 + 20, buffer_f32, 1);
                    buffer_poke(terrain.terrain_buffer_data, index4 + 20, buffer_f32, 1);
                    buffer_poke(terrain.terrain_buffer_data, index5 + 20, buffer_f32, 1);
                }
            }
            
            terrain_refresh_vertex_buffer(terrain);
        }, t_general);
        ds_list_add(t_heightmap.contents, element);
        
        yy += element.height + spacing;
        
        element = create_radio_array(legal_x + spacing, yy, "Deformation mode:", col_width, element_height, function(option) {
            Stuff.terrain.submode = option.root.value;
        }, mode.submode, t_heightmap);
        element.tooltip = "The method which you would like to use to mold the terrain.";
        create_radio_array_options(element, ["Mound", "Average", "Flat Average", "Zero (Erase)"]);
        t_heightmap.element_deform_mode = element;
        ds_list_add(t_heightmap.contents, element);
        
        yy += element.GetHeight() + spacing;
        
        element = create_text(legal_x + spacing, yy, "Deformation rate: " + string_format(mode.rate, 1, 3), col_width, element_height, fa_left, col_width, t_heightmap);
        t_heightmap.element_deform_rate = element;
        ds_list_add(t_heightmap.contents, element);
        
        yy += element.height + spacing;
        
        element = create_progress_bar(legal_x + spacing, yy, col_width, element_height, function(bar) {
            Stuff.terrain.rate = normalize(bar.value, Stuff.terrain.rate_min, Stuff.terrain.rate_max, 0, 1);
            bar.root.element_deform_rate.text = "Deformation rate: " + string_format(Stuff.terrain.rate, 1, 3);
        }, 4, normalize(mode.rate, 0, 1, mode.rate_min, mode.rate_max), t_heightmap);
        element.tooltip = "A smaller rate will give you more precision, and a larger rate will make the deformation more dramatic.";
        t_heightmap.element_deform_rate_bar = element;
        ds_list_add(t_heightmap.contents, element);
        
        yy += element.height + spacing;
        #endregion
        
        #region tab: texture
        yy = legal_y + spacing;
        
        element = create_button(legal_x + spacing, yy, "Set Mode: Texture", col_width, element_height, fa_center, function(button) {
            button.root.root.t_general.element_mode.value = TerrainModes.TEXTURE;
            Stuff.terrain.mode = TerrainModes.TEXTURE;
        }, t_general);
        ds_list_add(t_texture.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(legal_x + spacing, yy, "Save Texture", col_width, element_height, fa_center, function(button) {
            var terrain = Stuff.terrain;
            var fn = get_save_filename_image(terrain.texture_name);
            if (fn != "") {
                sprite_save(terrain.texture, 0, fn);
            }
        }, t_texture);
        ds_list_add(t_texture.contents, element);
        
        element = create_button(col2_x, yy, "Change Texture", col_width, element_height, fa_center, function(button) {
            var terrain = Stuff.terrain;
            var fn = get_open_filename_image();
            
            if (fn != "") {
                var sprite = sprite_add(fn, 0, false, false, 0, 0);
                if (sprite) {
                    sprite_delete(terrain.texture);
                    terrain.texture = sprite;
                    button.root.element_tile_selector.tileset = sprite;
                    terrain.texture_name = filename_name(fn);
                    button.root.element_texture_name.text = terrain.texture_name + " (" + string(terrain_texture_size) + " x " + string(terrain_texture_size) + ")";
                }
            }
        }, t_texture);
        ds_list_add(t_texture.contents, element);
        
        yy += element.height + spacing;
        
        element = create_text(legal_x + spacing, yy, mode.texture_name + " (" + string(terrain_texture_size) + " x " + string(terrain_texture_size) + ")", legal_width, element_height, fa_left, legal_width, t_texture);
        t_texture.element_texture_name = element;
        ds_list_add(t_texture.contents, element);
        
        yy += element.height + spacing;
        
        element = create_tile_selector(legal_x + spacing, yy, legal_width - spacing * 2, legal_width - spacing * 2, function(selector, x, y) {
            var terrain = Stuff.terrain;
            selector.tile_x = x;
            selector.tile_y = y;
            terrain.tile_brush_x = x * terrain_tile_size;
            terrain.tile_brush_y = y * terrain_tile_size;
        }, null, t_texture);
        element.tile_x = mode.tile_brush_x;
        element.tile_y = mode.tile_brush_y;
        element.tileset = mode.texture;
        t_texture.element_tile_selector = element;
        ds_list_add(t_texture.contents, element);
        
        yy += element.height + spacing;
        
        var yy_aftergrid = yy;
        
        element = create_button(legal_x + spacing, yy, "Clear Texture", col_width, element_height, fa_center, function(button) {
            var terrain = Stuff.terrain;
            
            for (var i = 0; i < terrain.width - 1; i++) {
                for (var j = 0; j < terrain.height - 1; j++) {
                    var index0 = terrain_get_vertex_index(terrain, i, j, 0);
                    var index1 = index0 + VERTEX_SIZE;
                    var index2 = index1 + VERTEX_SIZE;
                    var index3 = index2 + VERTEX_SIZE;
                    var index4 = index3 + VERTEX_SIZE;
                    var index5 = index4 + VERTEX_SIZE;
                    
                    buffer_poke(terrain.terrain_buffer_data, index0 + 24, buffer_f32, terrain.tile_brush_x + terrain_texture_texel);
                    buffer_poke(terrain.terrain_buffer_data, index1 + 24, buffer_f32, terrain.tile_brush_x + terrain_tile_size - terrain_texture_texel);
                    buffer_poke(terrain.terrain_buffer_data, index2 + 24, buffer_f32, terrain.tile_brush_x + terrain_tile_size - terrain_texture_texel);
                    buffer_poke(terrain.terrain_buffer_data, index3 + 24, buffer_f32, terrain.tile_brush_x + terrain_tile_size - terrain_texture_texel);
                    buffer_poke(terrain.terrain_buffer_data, index4 + 24, buffer_f32, terrain.tile_brush_x + terrain_texture_texel);
                    buffer_poke(terrain.terrain_buffer_data, index5 + 24, buffer_f32, terrain.tile_brush_x + terrain_texture_texel);
                    buffer_poke(terrain.terrain_buffer_data, index0 + 28, buffer_f32, terrain.tile_brush_y + terrain_texture_texel);
                    buffer_poke(terrain.terrain_buffer_data, index1 + 28, buffer_f32, terrain.tile_brush_y + terrain_texture_texel);
                    buffer_poke(terrain.terrain_buffer_data, index2 + 28, buffer_f32, terrain.tile_brush_y + terrain_tile_size - terrain_texture_texel);
                    buffer_poke(terrain.terrain_buffer_data, index3 + 28, buffer_f32, terrain.tile_brush_y + terrain_tile_size - terrain_texture_texel);
                    buffer_poke(terrain.terrain_buffer_data, index4 + 28, buffer_f32, terrain.tile_brush_y + terrain_tile_size - terrain_texture_texel);
                    buffer_poke(terrain.terrain_buffer_data, index5 + 28, buffer_f32, terrain.tile_brush_y + terrain_texture_texel);
                }
            }
            
            terrain_refresh_vertex_buffer(terrain);
        }, t_general);
        ds_list_add(t_texture.contents, element);
        
        yy += element.height + spacing;
        #endregion
        
        #region tab: painting
        yy = legal_y + spacing;
        
        element = create_button(legal_x + spacing, yy, "Set Mode: Paint", col_width, element_height, fa_center, function(button) {
            button.root.root.t_general.element_mode.value = TerrainModes.COLOR;
            Stuff.terrain.mode = TerrainModes.COLOR;
        }, t_general);
        ds_list_add(t_paint.contents, element);
        
        yy += element.height + spacing;
        
        element = create_text(legal_x + spacing, yy, "Paint strength: " + string(mode.paint_strength), col_width, element_height, fa_left, col_width, t_paint);
        t_paint.element_paint_strength = element;
        ds_list_add(t_paint.contents, element);
        
        yy += element.height + spacing;
        
        element = create_progress_bar(legal_x + spacing, yy, col_width, element_height, function(bar) {
            Stuff.terrain.paint_strength = normalize(bar.value, Stuff.terrain.paint_strength_min, Stuff.terrain.paint_strength_max, 0, 1);
            bar.root.element_paint_strength.text = "Paint strength: " + string(Stuff.terrain.paint_strength);
        }, 4, normalize(mode.paint_strength, 0, 1, mode.paint_strength_min, mode.paint_strength_max), t_paint);
        element.tooltip = "A lower strength value will cause the color to blend with the existing color, and a greater one will cause it to replace the existing color.";
        t_paint.element_paint_strength_bar = element;
        ds_list_add(t_paint.contents, element);
        
        yy += element.height + spacing;
        
        element = create_color_picker(legal_x + spacing, yy, "Color:", col_width, element_height, function(picker) {
            Stuff.terrain.paint_color = picker.value | (floor(picker.alpha * 255) << 24);
        }, mode.paint_color, vx1, vy1, vx2, vy2, t_paint);
        element.tooltip = "I really hope you enjoy this color picker because it was probably my favorite UI element to work on.";
        element.allow_alpha = true;
        t_paint.element_paint_color = element;
        ds_list_add(t_paint.contents, element);
        
        yy += element.height + spacing;
        
        element = create_button(legal_x + spacing, yy, "Clear Color", col_width, element_height, fa_center, function(button) {
            var terrain = Stuff.terrain;
            buffer_fill(terrain.color_data, 0, buffer_u32, terrain.paint_color, buffer_get_size(terrain.color_data));
            
            for (var i = 0; i < terrain.width - 1; i++) {
                for (var j = 0; j < terrain.height - 1; j++) {
                    var index0 = terrain_get_vertex_index(terrain, i, j, 0);
                    var index1 = index0 + VERTEX_SIZE;
                    var index2 = index1 + VERTEX_SIZE;
                    var index3 = index2 + VERTEX_SIZE;
                    var index4 = index3 + VERTEX_SIZE;
                    var index5 = index4 + VERTEX_SIZE;
                    
                    buffer_poke(terrain.terrain_buffer_data, index0 + 32, buffer_u32, terrain.paint_color);
                    buffer_poke(terrain.terrain_buffer_data, index1 + 32, buffer_u32, terrain.paint_color);
                    buffer_poke(terrain.terrain_buffer_data, index2 + 32, buffer_u32, terrain.paint_color);
                    buffer_poke(terrain.terrain_buffer_data, index3 + 32, buffer_u32, terrain.paint_color);
                    buffer_poke(terrain.terrain_buffer_data, index4 + 32, buffer_u32, terrain.paint_color);
                    buffer_poke(terrain.terrain_buffer_data, index5 + 32, buffer_u32, terrain.paint_color);
                }
            }
            
            terrain_refresh_vertex_buffer(terrain);
        }, t_general);
        ds_list_add(t_paint.contents, element);
        
        yy += element.height + spacing;
        #endregion
        
        return id;
    }
}