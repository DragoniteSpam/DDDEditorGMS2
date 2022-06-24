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
    
    static SetBounds = function() {
        var maxx = max(self.x1, self.x2);
        var maxy = max(self.y1, self.y2);
        var maxz = max(self.z1, self.z2);
        var minx = min(self.x1, self.x2);
        var miny = min(self.y1, self.y2);
        var minz = min(self.z1, self.z2);
        
        self.x1 = minx;
        self.y1 = miny;
        self.z1 = minz;
        self.x2 = maxx;
        self.y2 = maxy;
        self.z2 = maxz;
        self.zz = minz;
    };
    
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
        
        var element_width = 320;
        var element_height = 32;
        
        var col1 = 32;
        var col2 = 384;
        
        var dialog = emu_dialog_zone_template(zone, "Camera Zone Settings");
        
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
            self.root.zone.SetBounds();
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
        
        var element_width = 320;
        var element_height = 32;
        
        var col1 = 32;
        var col2 = 384;
        
        var dialog = emu_dialog_zone_template(zone, "Flag Zone Settings");
        dialog.width += 320;
        
        return dialog.AddContent([
            emu_bitfield_flags(col2, EMU_BASE, element_width, element_height, zone.zone_flags, function() {
                self.root.zone.zone_flags = self.value;
            }, "Misc. flags which you may enable or disable in sections of the map for various purposes. You can define asset flags in Global Game Settings.")
        ]).AddDefaultCloseButton();
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
        
        var element_width = 320;
        var element_height = 32;
        
        var col1 = 32;
        var col2 = 32 + 320 + 32;
        var col3 = 32 + 320 + 32 + 320 + 32;
        
        var dialog = emu_dialog_zone_template(zone, "Light Zone Settings");
        dialog.width += 320 + 32;
        dialog.zone = zone;
        
        return dialog.AddContent([
            (new EmuList(col2, EMU_BASE, element_width, element_height, "All lights:", element_height, 16, function() {
                if (!self.root) return;
                
                var selection = self.GetSelection();
                var active_lights = self.GetSibling("LIST");
                var active_selection = active_lights.GetSelection();
                
                if (active_selection != -1 && selection != -1) {
                    self.root.zone.lights[active_selection] = self.At(selection).REFID;
                }
            }))
                .SetEntryTypes(E_ListEntryTypes.STRUCTS)
                .SetList(ds_list_filter(Stuff.map.active_map.contents.all_entities, function(element) {
                    return ((element.etype_flags & ETypeFlags.ENTITY_EFFECT) >= ETypeFlags.ENTITY_EFFECT);
                }))
                .SetListColors(function(index) {
                    var effect = self.At(index);
                    return effect.com_light ? effect.com_light.label_colour : EMU_COLOR_INPUT_WARN;
                })
                .SetRefresh(function() {
                    var active_list = self.GetSibling("LIST");
                    var active_selection = active_list.GetSelection();
                    if (active_selection != -1 && self.GetSelection() != -1) {
                        self.root.zone.lights[active_selection] = self.GetSelectedItem().REFID;
                    }
                })
                .SetTooltip("Directional lights will be shown in green. Point lights will be shown in blue. I recommend giving, at the very least, all of your Light entities unique names. Deselecting this list will clear the active light index.")
                .SetID("ALL LIGHTS"),
            (new EmuList(col3, EMU_BASE, element_width, element_height, "Active lights:", element_height, 14, function() {
                if (!self.root) return;
                
                var selection = self.GetSelection();
                var all_lights = self.GetSibling("ALL LIGHTS");
                all_lights.Deselect();
                if (selection != -1) {
                    all_lights.Select(array_search(all_lights.entries, self.GetSelectedItem()));
                }
                self.root.Refresh();
            }))
                .SetListColors(function(index) {
                    var effect = refid_get(self.At(index));
                    return (effect && effect.com_light) ? effect.com_light.label_colour : EMU_COLOR_INPUT_WARN;
                })
                .SetEntryTypes(E_ListEntryTypes.OTHER, function(index) {
                    var entity = refid_get(self.At(index));
                    return entity ? entity.name : "<none>";
                })
                .SetVacantText("no active lights")
                .SetTooltip("Effects with no light component (eg if the light component has been removed) will be shown in red. One light will be reserved for the player at all times.")
                .SetList(zone.lights)
                .SetID("LIST"),
            (new EmuButton(col3, EMU_AUTO, element_width, element_height, "Clear", function() {
                if (self.GetSibling("LIST").GetSelection() == -1) return;
                self.root.zone.lights[self.GetSibling("LIST").GetSelection()] = NULL;
                self.GetSibling("ALL LIGHTS").Deselect();
            }))
                .SetID("CLEAR")
        ]).AddDefaultCloseButton();
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