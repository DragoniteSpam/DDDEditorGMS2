function MapZone(source, x1, y1, z1, x2, y2, z2) constructor {
    self.name = "";
    self.ztype = -1;
    self.zone_priority = 100;
    self.x1 = x1;
    self.y1 = y1;
    self.z1 = z1;
    self.x2 = x2;
    self.y2 = y2;
    self.z2 = z2;
    
    // this is updated with z1 just so that it can interface with Selection instances
    self.zz = z1;
    
    self.editor_color = c_white;
    
    static EditScript = function(root) { };
    
    // this is the base class, do not instantiate
    self.ExportBase = function(buffer) {
        buffer_write(buffer, buffer_string, self.ztype);
        buffer_write(buffer, buffer_string, self.name);
        buffer_write(buffer, buffer_f32, self.x1);
        buffer_write(buffer, buffer_f32, self.y1);
        buffer_write(buffer, buffer_f32, self.z1);
        buffer_write(buffer, buffer_f32, self.x2);
        buffer_write(buffer, buffer_f32, self.y2);
        buffer_write(buffer, buffer_f32, self.z2);
        buffer_write(buffer, buffer_u16, self.zone_priority);
    };
    
    self.Export = function(buffer) {
        self.ExportBase(buffer);
    };
    
    static Render = function() {
        var minx = min(self.x1, self.x2);
        var miny = min(self.y1, self.y2);
        var minz = min(self.z1, self.z2);
        var maxx = max(self.x2, self.x2);
        var maxy = max(self.y2, self.y2);
        var maxz = max(self.z2, self.z2);
        
        var x1 = minx * TILE_WIDTH;
        var y1 = miny * TILE_HEIGHT;
        var z1 = minz * TILE_DEPTH;
        // the outer corner of the cube is already at (32, 32, 32) so we need to
        // compensate for that
        var cube_bound = 32;
        var x2 = maxx * TILE_WIDTH - cube_bound;
        var y2 = maxy * TILE_HEIGHT - cube_bound;
        var z2 = maxz * TILE_DEPTH - cube_bound;
        var zone_color = (Stuff.map.selected_zone == self) ? c_array_zone_selected : self.editor_color;
        
        shader_set(shd_bounding_box);
        shader_set_uniform_f(shader_get_uniform(shd_bounding_box, "actual_color"), (zone_color & 0xff) / 0xff, ((zone_color > 8) & 0xff) / 0xff, ((zone_color >> 16) & 0xff) / 0xff);
        shader_set_uniform_f_array(shader_get_uniform(shd_bounding_box, "offsets"), [
            x1, y1, z1,
            x2, y1, z1,
            x1, y2, z1,
            x2, y2, z1,
            x1, y1, z2,
            x2, y1, z2,
            x1, y2, z2,
            x2, y2, z2,
        ]);
        
        vertex_submit(Stuff.graphics.indexed_cage_full, pr_trianglelist, -1);
        shader_reset();
    };
    
    static CreateJSONZone = function() {
        return {
            bounds: {
                x1: self.x1,
                y1: self.y1,
                z1: self.z1,
                x2: self.x2,
                y2: self.y2,
                z2: self.z2,
            },
            type: self.ztype,
            priority: self.zone_priority,
        };
    };
    
    static CreateJSON = function() {
        return self.CreateJSONZone();
    };
    
    static Destroy = function() {
        var map_contents = Stuff.map.active_map.contents;
        array_delete(map_contents.all_zones, array_search(map_contents.all_zones, self), 1);
    };
    
    if (is_struct(source)) {
        self.x1 = source.bounds.x1;
        self.y1 = source.bounds.y1;
        self.z1 = source.bounds.z1;
        self.x2 = source.bounds.x2;
        self.y2 = source.bounds.y2;
        self.z2 = source.bounds.z2;
        self.zone_priority = source.bounds.priority;
    }
}

function MapZoneCamera(source, x1, y1, z1, x2, y2, z2) : MapZone(source, x1, y1, z1, x2, y2, z2) constructor {
    self.editor_color = c_blue;
    self.ztype = MapZoneTypes.CAMERA;
    
    self.camera_distance = 8;
    self.camera_angle = 45;
    self.camera_easing_method = Easings.LINEAR;
    self.camera_easing_time = 1;
    
    self.Export = function(buffer) {
        self.ExportBase(buffer);
        buffer_write(buffer, buffer_u16, self.camera_distance);
        buffer_write(buffer, buffer_f32, self.camera_angle);
        buffer_write(buffer, buffer_u8, self.camera_easing_method);
        buffer_write(buffer, buffer_f32, self.camera_easing_time);
    };
    
    static EditScript = function() {
        var zone = Stuff.map.selected_zone;
        var map = Stuff.map.active_map;
        
        var element_width = 320;
        var element_height = 32;
    
        var col1 = 32;
        var col2 = 384;
        var col3 = 736;
    
        var dialog = new EmuDialog(32 + 320 + 32 + 320 + 32, 640, "Camera Zone Settings");
        dialog.zone = zone;
        
        dialog.AddContent([
            (new EmuText(col1, EMU_BASE, element_width, element_height, "[c_aqua]Physicality:")),
            (new EmuInput(col1, EMU_AUTO, element_width / 2, element_height, "x1:", zone.x1, "0..." + string(map.xx - 1), 4, E_InputTypes.INT, function() {
                self.root.x1 = real(self.value);
            }))
                .SetRealNumberBounds(0, map.xx - 1)
                .SetTooltip("The starting X coordinate of the zone."),
            (new EmuInput(col1 + element_width / 2, EMU_INLINE, element_width / 2, element_height, "x2:", zone.x2, "0..." + string(map.xx - 1), 4, E_InputTypes.INT, function() {
                self.root.x2 = real(self.value);
            }))
                .SetRealNumberBounds(0, map.xx - 1)
                .SetTooltip("The ending X coordinate of the zone."),
            (new EmuInput(col1, EMU_AUTO, element_width / 2, element_height, "y1:", zone.y1, "0..." + string(map.yy - 1), 4, E_InputTypes.INT, function() {
                self.root.y1 = real(self.value);
            }))
                .SetRealNumberBounds(0, map.yy - 1)
                .SetTooltip("The starting Y coordinate of the zone."),
            (new EmuInput(col1 + element_width / 2, EMU_INLINE, element_width / 2, element_height, "y2:", zone.y2, "0..." + string(map.yy - 1), 4, E_InputTypes.INT, function() {
                self.root.y2 = real(self.value);
            }))
                .SetRealNumberBounds(0, map.yy - 1)
                .SetTooltip("The ending Y coordinate of the zone."),
            (new EmuInput(col1, EMU_AUTO, element_width / 2, element_height, "z1:", zone.z1, "0..." + string(map.zz - 1), 4, E_InputTypes.INT, function() {
                self.root.z1 = real(self.value);
            }))
                .SetRealNumberBounds(0, map.zz - 1)
                .SetTooltip("The starting Z coordinate of the zone."),
            (new EmuInput(col1 + element_width / 2, EMU_INLINE, element_width / 2, element_height, "z2:", zone.z2, "0..." + string(map.zz - 1), 4, E_InputTypes.INT, function() {
                self.root.z2 = real(self.value);
            }))
                .SetRealNumberBounds(0, map.zz - 1)
                .SetTooltip("The ending Z coordinate of the zone."),
            (new EmuInput(col1, EMU_AUTO, element_width, element_height, "Priority:", zone.zone_priority, "1...1000", 4, E_InputTypes.INT, function() {
                self.root.zone_priority = real(self.value);
            }))
                .SetRealNumberBounds(1, 1000)
                .SetTooltip("If multiple zones overlap, the one with the highest priority will be the one that is acted upon."),
        ]);
        
        return dialog.AddContent([
            (new EmuText(col1, EMU_AUTO, element_width, element_height, "[c_aqua]Properties:")),
            (new EmuInput(col1, EMU_AUTO, element_width, element_height, "Distance:", zone.camera_distance, "1...100", 6, E_InputTypes.REAL, function() {
                self.root.camera_distance = real(self.value);
            }))
                .SetRealNumberBounds(1, 100)
                .SetTooltip("How far the camera is to be from its target, measured in tile distances. (Only affects 3D projections)."),
            (new EmuInput(col1, EMU_AUTO, element_width, element_height, "Angle:", zone.camera_angle, "-89...89", 6, E_InputTypes.REAL, function() {
                self.root.camera_angle = real(self.value);
            }))
                .SetRealNumberBounds(-89, 89)
                .SetTooltip("The angle above the ground of the camera, measured in degrees; a positive angle is looking down on the camera target, and a negative angle is looking up."),
            (new EmuInput(col1, EMU_AUTO, element_width, element_height, "Transition time:", zone.camera_easing_time, "0...30", 6, E_InputTypes.REAL, function() {
                self.root.camera_easing_time = real(self.value);
            }))
                .SetRealNumberBounds(0, 30)
                .SetTooltip("How long camera transitions should take, in seconds. A speed value of 0 is an instantaneous transition, and is not recommended."),
            (new EmuRadioArray(col2, EMU_BASE, element_width, element_height, "Easing:", zone.camera_easing_method, function() {
                self.root.zone.camera_easing_method = self.value;
            }))
                .AddOptions(array_clone(global.animation_tween_names))
                .SetColumns(16, element_width / 2)
                .SetTooltip("The transition used when you enter this camera zone. In almost all cases, Linear or Quadratic In/Out should be fine."),
            
            
        ]).AddDefaultCloseButton("Done", function() {
            map_zone_collision(self.root.zone);
            self.root.Dispose();
        });
    };
    
    static CreateJSONZoneCamera = function() {
        var json = self.CreateJSONZone();
        json.camera = {
            distance: self.camera_distance,
            angle: self.camera_angle,
            easing: self.camera_easing_method,
            time: self.camera_easing_time,
        };
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONZoneCamera();
    };
    
    if (is_struct(source)) {
        self.camera_distance = source.camera.distance;
        self.camera_angle = source.camera.angle;
        self.camera_easing_method = source.camera.easing;
        self.camera_easing_time = source.camera.time;
    }
}

function MapZoneFlag(source, x1, y1, z1, x2, y2, z2) : MapZone(source, x1, y1, z1, x2, y2, z2) constructor {
    self.editor_color = c_green;
    self.ztype = MapZoneTypes.FLAG;
    
    self.zone_flags = 0;
    
    self.Export = function(buffer) {
        self.ExportBase(buffer);
        buffer_write(buffer, buffer_u32, self.zone_flags);
    };
    
    static EditScript = function(root) {
        var zone = Stuff.map.selected_zone;
        var map = Stuff.map.active_map;
        
        var dw = 960;
        var dh = 640;
        
        var dg = dialog_create(dw, dh, "Flag Zone Settings: " + zone.name, dialog_default, dialog_destroy, root);
        
        var columns = 3;
        var spacing = 16;
        var ew = dw / columns - spacing * 2;
        var eh = 24;
        
        var col1_x = dw * 0 / columns + spacing;
        var col2_x = dw * 1 / columns + spacing;
        var col3_x = dw * 2 / columns + spacing;
        
        var vx1 = ew / 2;
        var vy1 = 0;
        var vx2 = ew;
        var vy2 = eh;
        
        var yy = 64;
        
        var el_name = create_input(col1_x, yy, "Name", ew, eh, uivc_input_map_zone_name, zone.name, "name", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
        el_name.tooltip = "A name; this is for identification (and possibly debugging) purposes and has no influence on gameplay";
        yy += el_name.height + spacing;
        
        var yy_base = yy;
        
        var el_bounds_text = create_text(col1_x, yy, "Bounds", ew, eh, fa_left, ew, dg);
        el_bounds_text.color = c_blue;
        
        yy += el_bounds_text.height + spacing;
        
        var bounds_x_help = "0..." + string(map.xx);
        var bounds_y_help = "0..." + string(map.yy);
        var bounds_z_help = "0..." + string(map.zz);
        
        var el_bounds_x1 = create_input(col1_x, yy, "X1:", ew, eh, uivc_input_map_zone_x1, zone.x1, bounds_x_help, validate_int, 0, map.xx, 4, vx1, vy1, vx2, vy2, dg);
        el_bounds_x1.tooltip = "The starting X coordinate of the camera zone. If the minimum and maximum bounds values are switched, the editor will automatically put them in order.";
        yy += el_bounds_x1.height + spacing;
        
        var el_bounds_y1 = create_input(col1_x, yy, "Y1:", ew, eh, uivc_input_map_zone_y1, zone.y1, bounds_y_help, validate_int, 0, map.yy, 4, vx1, vy1, vx2, vy2, dg);
        el_bounds_y1.tooltip = "The starting Y coordinate of the camera zone. If the minimum and maximum bounds values are switched, the editor will automatically put them in order.";
        yy += el_bounds_y1.height + spacing;
        
        var el_bounds_z1 = create_input(col1_x, yy, "Z1:", ew, eh, uivc_input_map_zone_z1, zone.z1, bounds_z_help, validate_int, 0, map.zz, 4, vx1, vy1, vx2, vy2, dg);
        el_bounds_z1.tooltip = "The starting Z coordinate of the camera zone. If the minimum and maximum bounds values are switched, the editor will automatically put them in order.";
        yy += el_bounds_z1.height + spacing;
        
        var el_bounds_x2 = create_input(col1_x, yy, "X2:", ew, eh, uivc_input_map_zone_x2, zone.x2, bounds_x_help, validate_int, 0, map.xx, 4, vx1, vy1, vx2, vy2, dg);
        el_bounds_x2.tooltip = "The ending X coordinate of the camera zone. If the minimum and maximum bounds values are switched, the editor will automatically put them in order.";
        yy += el_bounds_x2.height + spacing;
        
        var el_bounds_y2 = create_input(col1_x, yy, "Y2:", ew, eh, uivc_input_map_zone_y2, zone.y2, bounds_y_help, validate_int, 0, map.yy, 4, vx1, vy1, vx2, vy2, dg);
        el_bounds_y2.tooltip = "The ending Y coordinate of the camera zone. If the minimum and maximum bounds values are switched, the editor will automatically put them in order.";
        yy += el_bounds_y2.height + spacing;
        
        var el_bounds_z2 = create_input(col1_x, yy, "Z2:", ew, eh, uivc_input_map_zone_z2, zone.z2, bounds_z_help, validate_int, 0, map.zz, 4, vx1, vy1, vx2, vy2, dg);
        el_bounds_z2.tooltip = "The ending Z coordinate of the camera zone. If the minimum and maximum bounds values are switched, the editor will automatically put them in order.";
        yy += el_bounds_z2.height + spacing;
        
        var el_priority = create_input(col1_x, yy, "Priority:", ew, eh, uivc_input_map_zone_priority, zone.zone_priority, "int", validate_int, 0, 1000, 3, vx1, vy1, vx2, vy2, dg);
        el_priority.tooltip = "If multiple camera zones overlap, the one with the highest priority will be the one that is acted upon";
        yy += el_priority.height + spacing;
        
        yy = yy_base;
        
        var color_active = c_ui_select;
        var color_inactive = c_white;
        
        var el_asset_flags = create_bitfield(col2_x, yy, "Asset Flags", ew, eh, 0, dg);
        el_asset_flags.onvaluechange = function(bitfield) {
            Stuff.map.selected_zone.zone_flags = bitfield.value;
        };
        el_asset_flags.value = zone.zone_flags;
        
        // todo all flags, not just the first 32 bits
        for (var i = 0; i < 32; i++) {
            var field_xx = (i >= 16) ? ew : 0;
            // Each element will be positioned based on the one directly above it, so you
            // only need to move them up once otherwise they'll keep moving up the screen
            var field_yy = (i == 16) ? -(eh * 16) : 0;
            var label = (i >= array_length(Game.vars.flags)) ? "<" + string(i) + ">" : Game.vars.flags[i];
            create_bitfield_options_vertical(el_asset_flags, [create_bitfield_option_data(i, function(bitfield, x, y) {
                bitfield.state = bitfield.root.value & (1 << bitfield.value);
                ui_render_bitfield_option_text(bitfield, xx, yy);
            }, function(bitfield) {
                var base = bitfield.root;
                base.value = base.value ^ (1 << bitfield.value);
                base.onvaluechange(base);
            }, label, -1, 0, ew / 2, spacing / 2, field_xx, field_yy, color_active, color_inactive)]);
        }
        
        create_bitfield_options_vertical(el_asset_flags, [
            create_bitfield_option_data(32, function(bitfield, x, y) {
                bitfield.state = (base.value == 0xffffffff);
                ui_render_bitfield_option_text(bitfield.root, x, y);
            }, function(bitfield) {
                var base = bitfield.root;
                base.value = 0xffffffff;
                base.onvaluechange(base);
            }, "All", -1, 0, ew / 2, spacing / 2, 0, 0, color_active, color_inactive),
            create_bitfield_option_data(33, function(bitfield, x, y) {
                bitfield.state = (bitfield.root.value == 0);
                ui_render_bitfield_option_text(bitfield, x, y);
            }, function(bitfield) {
                var base = bitfield.root;
                base.value = 0;
                base.onvaluechange(base);
            }, "None", -1, 0, ew / 2, spacing / 2, ew, -eh, color_active, color_inactive),
        ]);
        
        el_asset_flags.tooltip = "Misc. flags which you may enable or disable. You can define asset flags in Global Game Settings.";
        
        var b_width = 128;
        var b_height = 32;
        var el_commit = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
        
        ds_list_add(dg.contents,
            el_name,
            el_bounds_text,
            el_bounds_x1,
            el_bounds_y1,
            el_bounds_z1,
            el_bounds_x2,
            el_bounds_y2,
            el_bounds_z2,
            el_priority,
            el_asset_flags,
            el_commit
        );
        
        return dg;
    };
    
    static CreateJSONZoneFlags = function() {
        var json = self.CreateJSONZone();
        json.flags = {
            flag: self.zone_flags,
        };
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONZoneFlags();
    };
    
    if (is_struct(source)) {
        self.zone_flags = source.flags.flag;
    }
}

function MapZoneLight(source, x1, y1, z1, x2, y2, z2) : MapZone(source, x1, y1, z1, x2, y2, z2) constructor {
    self.editor_color = c_yellow;
    self.ztype = MapZoneTypes.LIGHT;
    
    self.lights = array_create(MAX_LIGHTS, NULL);
    
    self.Export = function(buffer) {
        self.ExportBase(buffer);
        buffer_write(buffer, buffer_u8, array_length(zone.lights));
        for (var i = 0; i < array_length(zone.lights); i++) {
            buffer_write(buffer, buffer_datatype, zone.lights[i]);
        }
    };
    
    static EditScript = function(root) {
        var zone = Stuff.map.selected_zone;
        var map = Stuff.map.active_map;
        var map_contents = map.contents;
        
        var dw = 960;
        var dh = 480;
        
        var dg = dialog_create(dw, dh, "Light Zone Settings: " + zone.name, dialog_default, dialog_destroy, root);
        dg.zone = zone;
        
        var columns = 3;
        var spacing = 16;
        var ew = dw / columns - spacing * 2;
        var eh = 24;
        
        var col1_x = dw * 0 / columns + spacing;
        var col2_x = dw * 1 / columns + spacing;
        var col3_x = dw * 2 / columns + spacing;
        
        var vx1 = ew / 2;
        var vy1 = 0;
        var vx2 = ew;
        var vy2 = eh;
        
        var yy = 64;
        
        var el_name = create_input(col1_x, yy, "Name", ew, eh, uivc_input_map_zone_name, zone.name, "name", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
        el_name.tooltip = "A name; this is for identification (and possibly debugging) purposes and has no influence on gameplay";
        yy += el_name.height + spacing;
        
        var yy_base = yy;
        
        var el_bounds_text = create_text(col1_x, yy, "Bounds", ew, eh, fa_left, ew, dg);
        el_bounds_text.color = c_blue;
        
        yy += el_bounds_text.height + spacing;
        
        var bounds_x_help = "0..." + string(map.xx);
        var bounds_y_help = "0..." + string(map.yy);
        var bounds_z_help = "0..." + string(map.zz);
        
        var el_bounds_x1 = create_input(col1_x, yy, "X1:", ew, eh, uivc_input_map_zone_x1, zone.x1, bounds_x_help, validate_int, 0, map.xx, 4, vx1, vy1, vx2, vy2, dg);
        el_bounds_x1.tooltip = "The starting X coordinate of the camera zone. If the minimum and maximum bounds values are switched, the editor will automatically put them in order.";
        yy += el_bounds_x1.height + spacing;
        
        var el_bounds_y1 = create_input(col1_x, yy, "Y1:", ew, eh, uivc_input_map_zone_y1, zone.y1, bounds_y_help, validate_int, 0, map.yy, 4, vx1, vy1, vx2, vy2, dg);
        el_bounds_y1.tooltip = "The starting Y coordinate of the camera zone. If the minimum and maximum bounds values are switched, the editor will automatically put them in order.";
        yy += el_bounds_y1.height + spacing;
        
        var el_bounds_z1 = create_input(col1_x, yy, "Z1:", ew, eh, uivc_input_map_zone_z1, zone.z1, bounds_z_help, validate_int, 0, map.zz, 4, vx1, vy1, vx2, vy2, dg);
        el_bounds_z1.tooltip = "The starting Z coordinate of the camera zone. If the minimum and maximum bounds values are switched, the editor will automatically put them in order.";
        yy += el_bounds_z1.height + spacing;
        
        var el_bounds_x2 = create_input(col1_x, yy, "X2:", ew, eh, uivc_input_map_zone_x2, zone.x2, bounds_x_help, validate_int, 0, map.xx, 4, vx1, vy1, vx2, vy2, dg);
        el_bounds_x2.tooltip = "The ending X coordinate of the camera zone. If the minimum and maximum bounds values are switched, the editor will automatically put them in order.";
        yy += el_bounds_x2.height + spacing;
        
        var el_bounds_y2 = create_input(col1_x, yy, "Y2:", ew, eh, uivc_input_map_zone_y2, zone.y2, bounds_y_help, validate_int, 0, map.yy, 4, vx1, vy1, vx2, vy2, dg);
        el_bounds_y2.tooltip = "The ending Y coordinate of the camera zone. If the minimum and maximum bounds values are switched, the editor will automatically put them in order.";
        yy += el_bounds_y2.height + spacing;
        
        var el_bounds_z2 = create_input(col1_x, yy, "Z2:", ew, eh, uivc_input_map_zone_z2, zone.z2, bounds_z_help, validate_int, 0, map.zz, 4, vx1, vy1, vx2, vy2, dg);
        el_bounds_z2.tooltip = "The ending Z coordinate of the camera zone. If the minimum and maximum bounds values are switched, the editor will automatically put them in order.";
        yy += el_bounds_z2.height + spacing;
        
        yy = yy_base;
        
        var el_light_list = create_list(col2_x, yy, "Active Lights:", "<no active lights>", ew, eh, 12, function(list) {
            var all_list = list.root.el_available_lights;
            var active_selection = ui_list_selection(list);
            var all_selection = ui_list_selection(all_list);
            if (active_selection + 1) {
                ui_list_deselect(all_list);
                ui_list_select(all_list, ds_list_find_index(all_list.entries, list.entries[active_selection]), true);
            }
        }, false, dg, zone.lights);
        el_light_list.tooltip = "Directional lights will be shown in green. Point lights will be shown in blue. Effects with no light component (i.e. the light component has been removed) will be shown in red. Duplicate entries will be shown in orange. I recommend giving, at the very least, all of your Light entities unique names. One light will be reserved for the player at all times.";
        el_light_list.render_colors = ui_list_color_effect_components;
        el_light_list.entries_are = ListEntries.REFIDS;
        dg.el_light_list = el_light_list;
        yy += el_light_list.GetHeight() + spacing;
        
        yy = yy_base;
        
        var el_available_lights = create_list(col3_x, yy, "Available Lights:", "<no available lights>", ew, eh, 12, function(list) {
            var active_list = list.root.el_light_list;
            var selection = ui_list_selection(list);
            var active_selection = ui_list_selection(active_list);
            if (active_selection + 1) {
                if (selection + 1) {
                    active_list.entries[active_selection] = list.entries[| selection];
                } else {
                    active_list.entries[active_selection] = 0;
                }
            }
        }, false, dg);
        el_available_lights.tooltip = "Directional lights will be shown in green. Point lights will be shown in blue. I recommend giving, at the very least, all of your Light entities unique names. Deselecting this list will clear the active light index.";
        el_available_lights.entries_are = ListEntries.REFIDS;
        for (var i = 0; i < ds_list_size(map_contents.all_entities); i++) {
            var entity = map_contents.all_entities[| i];
            if (entity.etype == ETypes.ENTITY_EFFECT && entity.com_light) {
                create_list_entries(el_available_lights, [entity.REFID, entity.com_light.label_colour]);
            }
        }
        dg.el_available_lights = el_available_lights;
        
        yy += el_available_lights.GetHeight() + spacing;
        
        var b_width = 128;
        var b_height = 32;
        var el_commit = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
        
        ds_list_add(dg.contents,
            el_name,
            el_bounds_text,
            el_bounds_x1,
            el_bounds_y1,
            el_bounds_z1,
            el_bounds_x2,
            el_bounds_y2,
            el_bounds_z2,
            el_light_list,
            el_available_lights,
            el_commit
        );
        
        return dg;
    };
    
    static CreateJSONZoneLights = function() {
        var json = self.CreateJSONZone();
        json.lights = {
            data: self.lights,
        };
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONZoneLights();
    };
    
    if (is_struct(source)) {
        self.lights = source.lights.data;
    }
}