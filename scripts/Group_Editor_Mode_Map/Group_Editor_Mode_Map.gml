function EditorModeMap() : EditorModeBase() constructor {    self.ui = ui_init_main(self);
    self.mode_id = ModeIDs.MAP;
    
    self.camera = new Camera(256, 256, 128, 256, 0, 0, 0, 0, 1, 60, CAMERA_ZNEAR, CAMERA_ZFAR, function(mouse_vector) {
    
    });
    self.base_speed = 20;
    self.camera.Load(setting_get("map", "camera", undefined));
    self.camera.SetViewportAspect(function() {
        return Stuff.map.ui.SearchID("3D VIEWPORT").width;
    }, function() {
        return Stuff.map.ui.SearchID("3D VIEWPORT").height;
    });
    
    self.Update = function() {
    
    };
    
    self.Render = function() {
        draw_clear(EMU_COLOR_BACK);
        self.ui.Render(0, 0);
        draw_editor_menu(true);
    };
    
    self.Cleanup = editor_cleanup_map;
    
    self.Save = function() {
        Settings.map.camera = self.camera.Save();
    };
    
    self.changes = ds_list_create();
    
    self.under_cursor = noone;
    
    self.selection = [];
    self.selected_entities = ds_list_create();
    self.last_selection = undefined;
    self.selected_zone = noone;

    self.selection_fill_mesh = -1;       // list index
    self.selection_fill_tile_x = 4;
    self.selection_fill_tile_y = 0;
    self.selection_fill_tile_size = 32;  // make this a setting or something later
    self.edit_z = 0;
    
    enum SelectionModes {
        SINGLE,
        RECTANGLE,
        CIRCLE
    }
    
    enum FillTypes {
        TILE,
        TILE_ANIMATED,
        MESH,
        PAWN,
        EFFECT,
        TERRAIN,
        ZONE,
    }
    
    self.active_map = new DataMap("Test Map", "");
    self.active_map.contents = new MapContents(self.active_map);

    self.DrawEditor = function() {
        var map_contents = self.active_map.contents;
        
        draw_set_color(c_white);
        gpu_set_cullmode(Settings.view.backface ? cull_noculling : cull_counterclockwise);
        
        self.camera.SetProjection();
        //if (Settings.terrain.view_skybox) {
            //self.camera.DrawSkybox();
        //} else {
            draw_clear(Settings.config.color_world);
        //}
        
        if (Settings.terrain.orthographic) {
            self.camera.SetProjectionOrtho();
        } else {
            self.camera.SetProjection();
        }
        
        gpu_set_zwriteenable(true);
        gpu_set_ztestenable(true);
        
        // axes
        shader_set(shd_basic_colors);
        vertex_submit(Stuff.graphics.axes, pr_trianglelist, -1);
        
        graphics_set_lighting(shd_ddd);
        
        // this will need to be dynamic at some point
        var tex = Settings.view.texture ? sprite_get_texture(MAP_ACTIVE_TILESET.picture, 0) : sprite_get_texture(b_tileset_textureless, 0);
        
        #region entities
        if (Settings.view.entities) {
            if (map_contents.frozen) {
                vertex_submit(map_contents.frozen, pr_trianglelist, tex);
            }
            if (self.active_map.reflections_enabled && map_contents.reflect_frozen) {
                vertex_submit(map_contents.reflect_frozen, pr_trianglelist, tex);
            }
            
            if (map_contents.frozen) {
                wireframe_enable();
                vertex_submit(map_contents.frozen, pr_trianglelist, tex);
                if (self.active_map.reflections_enabled && map_contents.reflect_frozen) {
                    vertex_submit(map_contents.reflect_frozen, pr_trianglelist, tex);
                }
                wireframe_disable();
            }
            
            for (var i = 0, n = array_length(map_contents.batches); i < n; i++) {
                var data = map_contents.batches[i];
                vertex_submit(data.vertex, pr_trianglelist, tex);
                if (self.active_map.reflections_enabled) {
                    vertex_submit(data.reflect_vertex, pr_trianglelist, tex);
                }
            }
            
            if (Settings.view.wireframe) {
                wireframe_enable();
                for (var i = 0, n = array_length(map_contents.batches); i < n; i++) {
                    var data = map_contents.batches[i];
                    vertex_submit(data.vertex, pr_trianglelist, tex);
                    if (self.active_map.reflections_enabled) {
                        vertex_submit(data.reflect_vertex, pr_trianglelist, tex);
                    }
                }
                wireframe_disable();
            }
        }
        
        for (var i = 0; i < ds_list_size(map_contents.batch_in_the_future); i++) {
            map_contents.batch_in_the_future[| i].render(map_contents.batch_in_the_future[| i]);
            // batchable entities don't make use of move routes, so don't bother
        }
        
        // the water effect may use a different shader
        self.active_map.DrawWater();
        
        // reset the lighting shader after the water has been drawn
        graphics_set_lighting(shd_ddd);
        for (var i = 0; i < ds_list_size(map_contents.dynamic); i++) {
            map_contents.dynamic[| i].render(map_contents.dynamic[| i]);
        }
        #endregion
        
        shader_reset();
        gpu_set_cullmode(cull_noculling);
        
        #region grids, selection boxes, zones
        if (Settings.view.grid) {
            shader_set(shd_wireframe);
            transform_set(0, 0, self.edit_z * TILE_DEPTH + 0.5, 0, 0, 0, 1, 1, 1);
            vertex_submit(Stuff.graphics.grid, pr_linelist, -1);
            matrix_set(matrix_world, matrix_build_identity());
            shader_set(shd_ddd);
        }
        
        // tried using ztestenable for this - didn't look good. at all.
        for (var i = 0, n = array_length(self.selection); i < n; i++) {
            self.selection[i].render();
        }
        
        if (Settings.view.zones) {
            for (var i = 0, n = array_length(map_contents.all_zones); i < n; i++) {
                map_contents.all_zones[i].Render();
            }
        }
        #endregion
        
        #region unlit meshes - UI stuff like axes and gizmos
        if (Game.meta.start.map == self.active_map.GUID) {
            transform_set(0, 0, 0, 0, 0, Stuff.direction_lookup[Game.meta.start.direction], 1, 1, 1);
            transform_add((Game.meta.start.x + 0.5) * TILE_WIDTH, (Game.meta.start.y + 0.5) * TILE_HEIGHT, Game.meta.start.z * TILE_DEPTH, 0, 0, 0, 1, 1, 1);
            vertex_submit(Stuff.graphics.basic_cage, pr_trianglelist, -1);
        }
        
        // check for the gizmo setting in the actual events where this list is contributed
        // to - there may be some you want to draw regardless, like component axes
        while (!ds_queue_empty(Stuff.unlit_meshes)) {
            var data = ds_queue_dequeue(Stuff.unlit_meshes);
            var vbuffer = data[0];
            var transform = data[1];
            matrix_set(matrix_world, transform);
            vertex_submit(vbuffer, pr_trianglelist, -1);
        }
        #endregion
        
        matrix_set(matrix_world, matrix_build_identity());
        shader_reset();
        
        #region overlay stuff - draw_camera_controls_overlay exists, but i'd actually rather not use it for this
        gpu_set_ztestenable(false);
        var cwidth = camera_get_view_width(camera);
        var cheight = camera_get_view_height(camera);
        camera_set_view_mat(camera, matrix_build_lookat(cwidth / 2, cheight / 2, 16000,  cwidth / 2, cheight / 2, -16000, 0, 1, 0));
        camera_set_proj_mat(camera, matrix_build_projection_ortho(-cwidth, cheight, CAMERA_ZNEAR, CAMERA_ZFAR));
        camera_apply(camera);
        
        #region height controls
        // base bar
        var height = clamp(24 * self.active_map.zz, 64, 640);
        var sw = sprite_get_width(spr_vertical_bar);
        var sh = sprite_get_height(spr_vertical_bar);
        var bw = sprite_get_width(spr_plus_minus_button);
        var bh = sprite_get_height(spr_plus_minus_button);
        var yy_start = 64 + bh;
        var yy_end = 64 + height - bh;
        draw_sprite_stretched(spr_vertical_bar, 0, 32 - sw / 2, 64, sw, height);
        
        // bar notches
        var notch_count = min(power(2, floor(log2(max(self.active_map.zz, 2)))), 16);
        for (var i = 0; i < notch_count; i++) {
            var yy_notch = yy_start + i * (yy_end - yy_start) / (notch_count - 1);
            draw_line_width_colour(32 - bw / 4, yy_notch, 32 + bw / 4, yy_notch, 2, c_ui_select, c_ui_select);
        }
        
        // buttons
        var overlap_plus = mouse_within_rectangle(32 - bw / 2, 64 - bh / 2, 32 + bw / 2, 64 + bh / 2);
        var overlap_minus = mouse_within_rectangle(32 - bw / 2, 64 + height - bh / 2, 32 + bw / 2, 64 + height + bh / 2);
        draw_sprite_ext(spr_plus_minus_button, 0, 32, 64, 1, 1, 0, overlap_plus ? c_ui_select : c_white, 1);
        draw_sprite_ext(spr_plus_minus_button, 1, 32, height + 64, 1, 1, 0, overlap_minus ? c_ui_select : c_white, 1);
        
        // slider
        var slider_length = height - bh * 2;
        var interval = slider_length / (self.active_map.zz - 1);
        var slider_y = 64 + height - bh - self.edit_z * interval;
        var slw = sprite_get_width(spr_drag_handle_vertical);
        var slh = sprite_get_height(spr_drag_handle_vertical);
        var overlap_slider = mouse_within_rectangle(32 - slw / 2, slider_y - slh / 2, 32 + slw / 2, slider_y + slh / 2);
        draw_sprite_ext(spr_drag_handle_vertical, 0, 32, slider_y, 1, 1, 0, overlap_slider ? c_ui_select : c_white, 1);
        
        // interactions
        if (ds_list_empty(Stuff.dialogs)) {
            var overlap_interval = mouse_within_rectangle(32 - slw / 2, 64, 32 + slw / 2, 64 + height);
            
            if (overlap_plus) {
                if (mouse_check_button_pressed(mb_left)) {
                    self.edit_z = min(++self.edit_z, self.active_map.zz - 1);
                }
                mouse_over_ui = true;
            } else if (overlap_minus) {
                if (mouse_check_button_pressed(mb_left)) {
                    self.edit_z = max(--self.edit_z, 0);
                }
                mouse_over_ui = true;
            } else if (overlap_interval) {
                if (mouse_check_button(mb_left)) {
                    var f = clamp((yy_end - mouse_y) / (yy_end - yy_start), 0, 1);
                    self.edit_z = round(f * (self.active_map.zz - 1));
                }
                mouse_over_ui = true;
            }
        }
        #endregion
        
        #region icons
        while (!ds_queue_empty(Stuff.screen_icons)) {
            var data = ds_queue_dequeue(Stuff.screen_icons);
            var sprite = data[0];
            var position = data[1];
            draw_sprite(sprite, 0, position.x, position.y);
        }
        #endregion
        #endregion
    };
    
    self.mouse_over_ui = false;
}
