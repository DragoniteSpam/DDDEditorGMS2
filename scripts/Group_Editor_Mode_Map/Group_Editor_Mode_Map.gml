function EditorModeMap() : EditorModeBase() constructor {
    self.ui = ui_init_main(self);
    self.mode_id = ModeIDs.MAP;
    
    var threed_surface = self.ui.SearchID("3D VIEW");
    self.camera = new Camera(256, 256, 128, 256, 0, 0, 0, 0, 1, 60, CAMERA_ZNEAR, CAMERA_ZFAR, function(mouse_vector) {
        var mode = Stuff.map;
        var threed_surface = mode.ui.SearchID("3D VIEW");
        var input_control = keyboard_check(vk_control);
        
        var instance_under_cursor = undefined;
        var mouse_position = new Vector2(window_mouse_get_x() - threed_surface.x, window_mouse_get_y() - threed_surface.y);
        
        if (!mode.mouse_over_ui) {
            #region process the stuff you clicked on
            if (mouse_vector.direction.z < 0) {
                var f = abs((self.z - (mode.edit_z * TILE_DEPTH)) / mouse_vector.direction.z);
                
                var floor_x = self.x + mouse_vector.direction.x * f;
                var floor_y = self.y + mouse_vector.direction.y * f;
                var floor_z = mode.edit_z * TILE_DEPTH;
                
                // the bounds on this are weird - in some places the cell needs to be
                // rounded up and in others it needs to be rounded down, so the minimum
                // allowed "cell" is (-1, -1) - be sure to max() this later if it
                // would cause issues
                var floor_cx = clamp(floor_x div TILE_WIDTH, -1, mode.active_map.xx - 1);
                var floor_cy = clamp(floor_y div TILE_HEIGHT, -1, mode.active_map.yy - 1);
                var floor_cz = clamp(floor_z div TILE_DEPTH, -1, mode.active_map.zz - 1);
                
                if (mouse_position.x > 0 && mouse_position.y && mouse_position.x < threed_surface.width - 1 && mouse_position.y < threed_surface.height - 1) {
                    if (Controller.press_left) {
                        if (array_length(mode.selection) < MAX_SELECTION_COUNT) {
                            if (!keyboard_check(Controller.input_selection_add) && !Settings.selection.addition) {
                                selection_clear();
                            }
                            var stype = SelectionRectangle;
                            switch (Settings.selection.mode) {
                                case MapSelectionModes.SINGLE: stype = SelectionSingle; break;
                                case MapSelectionModes.RECTANGLE: stype = SelectionRectangle; break;
                            }
                        
                            var button = mode.ui.SearchID("ZONE DATA");
                            button.text = "Zone Data";
                            button.SetInteractive(false);
                            mode.selected_zone = undefined;
                        
                            if (instance_under_cursor && instance_under_cursor.ztype != undefined) {
                                button.interactive = true;
                                button.onmouseup = instance_under_cursor.EditScript;
                                button.text = "Data: " + instance_under_cursor.name;
                                mode.selected_zone = instance_under_cursor;
                            } else {
                                var tz = instance_under_cursor ? max(instance_under_cursor.zz, mode.edit_z) : mode.edit_z;
                                mode.last_selection = new stype(max(0, floor_cx), max(0, floor_cy), tz);
                            }
                        }
                    }
                
                    if (Controller.mouse_left) {
                        if (mode.last_selection) {
                            mode.last_selection.onmousedrag(floor_cx + 1, floor_cy + 1);
                        }
                    }
                
                    if (Controller.release_left) {
                        // selections of zero area are just deleted outright
                        if (mode.last_selection) {
                            if (mode.last_selection.area() == 0) {
                                array_pop(mode.selection);
                                mode.last_selection = undefined;
                            }
                            sa_process_selection();
                        }
                    }
                
                    if (Controller.press_right) {
                        Controller.press_right = false;
                        // if there is no selection, select the single square under the
                        // cursor. Otherwise you might want to do operations on large
                        // swaths of entities, so don't clear it or anythign like that.
                    
                        if (selection_empty()) {
                            mode.last_selection = new SelectionSingle(floor_cx, floor_cy, instance_under_cursor ? instance_under_cursor.zz : 0);
                        }
                    
                        var menu = Stuff.menu.menu_right_click;
                        menu_activate_extra(menu);
                        menu.x = mouse_x;
                        menu.y = mouse_y;
                    }
                }
            }
            #endregion
        
            #region main map editing actions
            if (!input_control) {
                if (keyboard_check_pressed(vk_space)) {
                    sa_fill();
                }
                if (keyboard_check_pressed(vk_delete)) {
                    sa_delete();
                }
            }
            #endregion
        }
    
        mode.mouse_over_ui = false;
        if (instance_under_cursor) mode.under_cursor = instance_under_cursor;
    });
    self.base_speed = 20;
    self.camera.Load(setting_get("map", "camera", undefined));
    self.camera.SetCenter(threed_surface.x + threed_surface.width / 2, threed_surface.y + threed_surface.height / 2);
    self.camera.SetViewportAspect(function() {
        return Stuff.map.ui.SearchID("3D VIEW").width;
    }, function() {
        return Stuff.map.ui.SearchID("3D VIEW").height;
    });
    self.camera.SetSkybox(Stuff.graphics.skybox_base, Stuff.graphics.default_skybox);
    
    self.SetMode = function() {
        editor_set_mode(self, ModeIDs.MAP);
    };
    
    self.Update = function() {
    
    };
    
    self.Render = function() {
        draw_clear(EMU_COLOR_BACK);
        Stuff.base_camera.SetProjectionGUI();
        self.ui.Render(0, 0);
        editor_gui_post();
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

    self.selection_fill_tile_x = 4;
    self.selection_fill_tile_y = 0;
    self.selection_fill_tile_size = 32;  // make this a setting or something later
    self.edit_z = 0;
    self.mouse_over_ui = false;
    
    enum MapSelectionModes {
        SINGLE,
        RECTANGLE,
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
    
    self.active_map = Game.maps[0];
    self.active_map.contents = new MapContents(self.active_map);
    
    self.DrawEditor = function() {
        var map_contents = self.active_map.contents;
        
        #region Clear the screen and set things up
        draw_clear(Settings.config.color_world);
        
        self.camera.SetProjection();
        if (Settings.terrain.view_skybox) {
            self.camera.SetSkybox(Stuff.graphics.skybox_base, guid_get(self.active_map.skybox) ? guid_get(self.active_map.skybox).picture : -1);
            self.camera.DrawSkybox();
        }
        
        if (Settings.terrain.orthographic) {
            self.camera.SetProjectionOrtho();
        } else {
            self.camera.SetProjection();
        }
        
        Stuff.graphics.DrawAxes();
        #endregion
        
        gpu_set_zwriteenable(true);
        gpu_set_ztestenable(true);
        graphics_set_lighting(shd_ddd);
        wireframe_enable(Settings.view.wireframe, 512);
        
        #region terrain
        var terrain = guid_get(self.active_map.terrain.id);
        if (terrain) {
            var scale = self.active_map.terrain.scale;
            matrix_set(matrix_world, matrix_build(0, 0, 0, 0, 0, 0, scale, scale, scale));
            var texture_data = guid_get(terrain.tex_base);
            var tex = texture_data ? sprite_get_texture(texture_data.picture, 0) : -1;
            for (var i = 0, n = array_length(terrain.submeshes); i < n; i++) {
                vertex_submit(terrain.submeshes[i].vbuffer, pr_trianglelist, tex);
            }
            matrix_set(matrix_world, matrix_build_identity());
        }
        #endregion
        
        // this will need to be dynamic at some point
        var tex = Settings.view.texture ? sprite_get_texture(MAP_ACTIVE_TILESET.picture, 0) : sprite_get_texture(b_tileset_textureless, 0);
        
        #region entities
        if (Settings.view.frozen) {
            if (map_contents.frozen) {
                vertex_submit(map_contents.frozen, pr_trianglelist, tex);
            }
            if (self.active_map.reflections_enabled && map_contents.reflect_frozen) {
                vertex_submit(map_contents.reflect_frozen, pr_trianglelist, tex);
            }
        }
        
        if (Settings.view.entities) {    
            for (var i = 0, n = array_length(map_contents.batches); i < n; i++) {
                var data = map_contents.batches[i];
                vertex_submit(data.vertex, pr_trianglelist, tex);
                if (self.active_map.reflections_enabled) {
                    vertex_submit(data.reflect_vertex, pr_trianglelist, tex);
                }
            }
            
            for (var i = 0, n = ds_list_size(map_contents.batch_in_the_future); i < n; i++) {
                map_contents.batch_in_the_future[| i].render(map_contents.batch_in_the_future[| i]);
            }
            
            for (var i = 0, n = ds_list_size(map_contents.dynamic); i < n; i++) {
                map_contents.dynamic[| i].render(map_contents.dynamic[| i]);
            }
        }
        #endregion
        
        // the water effect may use a different shader
        wireframe_enable(Settings.view.wireframe, 512);
        self.active_map.DrawWater();
        
        gpu_set_cullmode(cull_noculling);
        
        #region grids, selection boxes, zones
        if (Settings.view.grid) Stuff.graphics.DrawMapGrid(0, 0, self.edit_z * TILE_DEPTH + 0.5, 0, 0, 0, 1, 1, 1);
        
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
            Stuff.graphics.DrawBasicCage((Game.meta.start.x + 0.5) * TILE_WIDTH, (Game.meta.start.y + 0.5) * TILE_HEIGHT, Game.meta.start.z * TILE_DEPTH, 0, 0, Stuff.direction_lookup[Game.meta.start.direction], 1, 1, 1);
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
        
        gpu_set_zwriteenable(false);
        gpu_set_ztestenable(false);
        
        #region overlay stuff
        self.camera.SetProjectionGUI();
        
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
        editor_gui_button(spr_camera_icons, 2, 16, window_get_height() - 48, 0, 0, null, function() {
            self.camera.Reset();
        });
        
        editor_gui_button(spr_plus_minus_button, 3, 16, 32, 0, 0, function() {
            self.mouse_over_ui = true;
        }, function() {
            self.edit_z = min(++self.edit_z, self.active_map.zz - 1);
        });
        editor_gui_button(spr_plus_minus_button, 0, 16, 64 + height, 0, 0, function() {
            self.mouse_over_ui = true;
        }, function() {
            self.edit_z = max(--self.edit_z, 0);
        });
        
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
            
            if (overlap_interval) {
                if (mouse_check_button(mb_left)) {
                    var f = clamp((yy_end - mouse_y) / (yy_end - yy_start), 0, 1);
                    self.edit_z = round(f * (self.active_map.zz - 1));
                }
                mouse_over_ui = true;
            }
        }
        #endregion
        
        #region icons from world space
        while (!ds_queue_empty(Stuff.screen_icons)) {
            var data = ds_queue_dequeue(Stuff.screen_icons);
            var sprite = data[0];
            var position = data[1];
            draw_sprite(sprite, 0, position.x, position.y);
        }
        #endregion
    };
}


