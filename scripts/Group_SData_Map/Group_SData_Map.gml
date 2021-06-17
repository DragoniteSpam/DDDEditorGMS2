function DataMap(source) : SData(source) constructor {
    self.data_buffer = buffer_create(1, buffer_grow, 1);
    self.contents = undefined;
    self.version = DataVersions._CURRENT;
    self.tiled_map_id = -1;
    self.preview = undefined;
    self.wpreview = undefined;
    self.cspreview = undefined;
    self.cpreview = undefined;
    
    self.on_grid = true;
    self.xx = 64;
    self.yy = 64;
    self.zz = 8;
    self.tileset = NULL;                             // GUID
    self.is_3d = true;                               // bool
    self.fog_start = 1024;                           // float
    self.fog_end = 3072;                             // float
    self.fog_enabled = true;                         // bool
    self.fog_colour = c_white;                       // uint
    self.indoors = false;                            // bool
    self.draw_water = true;                          // bool
    self.water_level = 0;                            // float
    self.reflections_enabled = true;                 // bool
    self.fast_travel_to = true;                      // bool
    self.fast_travel_from = true;                    // bool
    self.base_encounter_rate = 8;                    // steps?
    self.base_encounter_deviation = 4;               // ehh
    self.light_enabled = true;                       // bool
    self.light_ambient_colour = c_white;             // uint
    self.light_player_enabled = true;                // bool
    self.skybox = NULL;                              // GUID
    self.map_chunk_size = 32;                        // int
    
    self.discovery = 0;                              // index
    self.code = Stuff.default_lua_map;               // code
    self.generic_data = [];                          // similar to that attached to Entities
    
    if (is_struct(source)) {
        self.xx = source.xx;
        self.yy = source.yy;
        self.zz = source.zz;
        self.tiled_map_id = source.tiled_map_id;
        self.on_grid = source.on_grid;
        self.tileset = source.tileset;
        self.is_3d = source.is_3d;
        self.fog_start = source.fog_start;
        self.fog_end = source.fog_end;
        self.fog_enabled = source.fog_enabled;
        self.fog_colour = source.fog_colour;
        self.indoors = source.indoors;
        self.draw_water = source.draw_water;
        self.water_level = source.water_level;
        self.reflections_enabled = source.reflections_enabled;
        self.fast_travel_to = source.fast_travel_to;
        self.fast_travel_from = source.fast_travel_from;
        self.base_encounter_rate = source.base_encounter_rate;
        self.base_encounter_deviation = source.base_encounter_deviation;
        self.light_enabled = source.light_enabled;
        self.light_ambient_colour = source.light_ambient_colour;
        self.light_player_enabled = source.light_player_enabled;
        self.skybox = source.skybox;
        self.map_chunk_size = source.map_chunk_size;
        self.discovery = source.discovery;
        self.code = source.code;
        self.generic_data = source.generic_data;
    }
    
    static Add = function(entity, x, y, z, is_temp, add_to_lists) {
        if (x == undefined) x = entity.xx;
        if (y == undefined) y = entity.yy;
        if (z == undefined) z = entity.zz;
        if (is_temp == undefined) is_temp = false;
        if (add_to_lists == undefined) add_to_lists = true;
        // Does not check to see if the specified coordinates are in bounds.
        // You are responsible for that.
        
        var cell = self.contents.map_grid[x][y][z];
        
        // only add thing if the space is not already occupied
        if (!cell[@ entity.slot]) {
            cell[@ entity.slot] = entity;
            
            entity.xx = x;
            entity.yy = y;
            entity.zz = z;
            
            entity.SetCollisionTransform();
            
            if (add_to_lists) {
                ds_list_add(self.contents.all_entities, entity);
            }
            
            // set that argument to false to avoid adding the instance to a list - this might
            // be because it's a temporary instance, or perhaps it's already in the map and you're
            // just trying to move it
            if (!is_temp && add_to_lists) {
                var list = entity.batchable ? self.contents.batch_in_the_future : self.contents.dynamic;
                // smf meshes simply aren't allowed to be batched, or static, so exert your authority over them
                if (instanceof_classic(entity, EntityMesh) && guid_get(entity.mesh) && guid_get(entity.mesh).type == MeshTypes.SMF) {
                    list = self.contents.dynamic;
                }
                
                ds_list_add(list, entity);
                entity.listed = true;
                ds_list_add(Stuff.map.changes, entity);
            }
        } else {
            safa_delete(entity);
        }
    };
    
    static FreeAt = function(x, y, z, slot) {
        return !self.contents.map_grid[x][y][z][slot];
    };
    
    static Get = function(x, y, z) {
        return self.contents.map_grid[x][y][z];
    };
    
    static GetMeshAutotileData = function(x, y, z) {
        if (!is_clamped(x, 0, self.xx - 1) || !is_clamped(y, 0, self.yy - 1) || !is_clamped(z, 0, self.zz - 1)) return false;
        
        var what = self.contents.map_grid[x][y][z][MapCellContents.MESH];
        var result = (instanceof_classic(what, EntityMeshAutotile) && what.modification != Modifications.REMOVE);
        
        if (z < self.zz - 1) {
            // check the cell above you for a tile, because tiles kinda appear to
            // exist on the layer below where they actually are
            what = self.contents.map_grid[x][y][z + 1][MapCellContents.MESH];
            result = result || (what && what.modification != Modifications.REMOVE);
        }
        
        return result;
    };
    
    static GetFlag = function(x, y, z) {
        return self.contents.map_grid_tags[x][y][z];
    };
    
    static SetFlag = function(x, y, z, flag) {
        self.contents.map_grid_tags[@ x][@ y][@ z] = flag;
    };
    
    static Move = function(entity, x, y, z, mark_changed) {
        if (mark_changed == undefined) mark_changed = true;
        
        if (self.FreeAt(x, y, z, entity.slot)) {
            self.Remove(entity);
            self.Add(entity, x, y, z, false, false);
            if (mark_changed) {
                editor_map_mark_changed(entity);
            }
        }
    };
    
    static Remove = function(entity) {
        var cell = self.contents.map_grid[entity.xx][entity.yy][entity.zz];
        if (cell[entity.slot] == entity) {
            cell[@ entity.slot] = undefined;
        }
    };
    
    static LoadAsset = function(directory) {
        directory += "/";
        var guid = string_replace(self.GUID, ":", "_");
        
        #region zones
        var zone_meta = json_parse(buffer_read_file(directory + "zones.json"));
        for (var i = 0; i < array_length(zone_meta.zones); i++) {
            var zone_data = zone_meta.zones[i];
            instance_create_depth(0, 0, 0, global.map_zone_type_objects[zone_data.type]).LoadJSON(zone_data);
        }
        #endregion
    };
    
    static SaveAsset = function(directory) {
        if (!self.contents) return;
        directory += "/" + string_replace(self.GUID, ":", "_") + "/";
        if (!directory_exists(directory)) directory_create(directory);
        
        #region zones
        var zone_meta = {
            zones: array_create(ds_list_size(self.contents.all_zones)),
        }
        for (var i = 0, n = ds_list_size(self.contents.all_zones); i < n; i++) {
            zone_meta.zones[i] = self.contents.all_zones[| i].CreateJSON();
        }
        buffer_write_file(json_stringify(zone_meta), directory + "zones.json");
        #endregion
        
        #region entities
        var entity_meta = {
            entities: array_create(ds_list_size(self.contents.all_entities)),
        };
        var entity_data = {
            entities: array_create(ds_list_size(self.contents.all_entities)),
        };
        for (var i = 0, n = ds_list_size(self.contents.all_entities); i < n; i++) {
            entity_meta.entities[i] = self.contents.all_entities[| i].REFID;
            entity_data.entities[i] = self.contents.all_entities[| i].CreateJSON(directory);
        }
        buffer_write_file(json_stringify(entity_meta), directory + "entities.json");
        buffer_write_file(json_stringify(entity_data), directory + "entities.ass");
        #endregion
    };
    
    static CreateJSONMap = function() {
        var json = self.CreateJSONBase();
        json.xx = self.xx;
        json.yy = self.yy;
        json.zz = self.zz;
        json.tiled_map_id = self.tiled_map_id;
        json.on_grid = self.on_grid;
        json.tileset = self.tileset;
        json.is_3d = self.is_3d;
        json.fog_start = self.fog_start;
        json.fog_end = self.fog_end;
        json.fog_enabled = self.fog_enabled;
        json.fog_colour = self.fog_colour;
        json.indoors = self.indoors;
        json.draw_water = self.draw_water;
        json.water_level = self.water_level;
        json.reflections_enabled = self.reflections_enabled;
        json.fast_travel_to = self.fast_travel_to;
        json.fast_travel_from = self.fast_travel_from;
        json.base_encounter_rate = self.base_encounter_rate;
        json.base_encounter_deviation = self.base_encounter_deviation;
        json.light_enabled = self.light_enabled;
        json.light_ambient_colour = self.light_ambient_colour;
        json.light_player_enabled = self.light_player_enabled;
        json.skybox = self.skybox;
        json.map_chunk_size = self.map_chunk_size;
        json.discovery = self.discovery;
        json.code = self.code;
        json.generic_data = self.generic_data;
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONMap();
    };
    
    static Destroy = function() {
        if (self.contents) self.contents.Destroy();
        
        buffer_delete(self.data_buffer);
        if (self.preview) buffer_delete(self.preview);
        if (self.wpreview) buffer_delete(self.wpreview);
        if (self.cpreview) c_world_remove_object(self.cpreview);
        if (self.cpreview) c_object_destroy(self.cpreview);
        if (self.cspreview) c_shape_destroy(self.cspreview);
        
        ds_list_delete(Game.maps, ds_list_find_index(Game.maps, self));
    };
}