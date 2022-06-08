function DataMap(source, directory) : SData(source) constructor {
    self.directory = directory;
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
    self.tileset = NULL;                                                        // GUID
    self.water_texture = NULL;                                                  // GUID
    self.fog_start = 1024;                                                      // float
    self.fog_end = 3072;                                                        // float
    self.fog_enabled = true;                                                    // bool
    self.fog_colour = c_white;                                                  // uint
    self.indoors = false;                                                       // bool
    self.draw_water = true;                                                     // bool
    self.water_level = 0;                                                       // float
    self.reflections_enabled = true;                                            // bool
    self.fast_travel_to = true;                                                 // bool
    self.fast_travel_from = true;                                               // bool
    self.base_encounter_rate = 8;                                               // steps?
    self.base_encounter_deviation = 4;                                          // ehh
    self.light_enabled = true;                                                  // bool
    self.light_ambient_colour = c_white;                                        // uint
    self.light_player_enabled = true;                                           // bool
    self.skybox = NULL;                                                         // GUID
    self.chunk_size = 32;                                                       // int
    
    self.terrain = {
        id: NULL,                                                               // GUID
        scale: 1,                                                               // float
    };
    
    self.grid_flags = array_create_3d(self.xx, self.yy, self.zz);               // 3D flag array
    self.lights = array_create(MAX_LIGHTS, NULL);                               // GUID array
    self.discovery = 0;                                                         // index
    self.code = "";                                                             // code
    self.generic_data = [];                                                     // similar to that attached to Entities
    
    // not saved to project - this is auto-generated when you export
    self.export = {
        index: 0,
        address: 0,
        size: 0,
    };
    
    static Add = function(entity, x = entity.xx, y = entity.yy, z = entity.zz, is_temp = false, add_to_lists = true) {
        if (!self.on_grid) {
            self.AddOffGrid(entity, x, y, z);
            return;
        }
        
        // Does not check to see if the specified coordinates are in bounds.
        // You are responsible for that.
        
        var cell = self.contents.map_grid[x][y][z];
        
        // only add thing if the space is not already occupied
        if (!cell[@ entity.slot]) {
            cell[@ entity.slot] = entity;
            
            entity.xx = x;
            entity.yy = y;
            entity.zz = z;
            
            if (add_to_lists) {
                ds_list_add(self.contents.all_entities, entity);
            }
            
            // set that argument to false to avoid adding the instance to a list - this might
            // be because it's a temporary instance, or perhaps it's already in the map and you're
            // just trying to move it
            if (!is_temp && add_to_lists) {
                var list = (entity.batchable && MAP_BATCH_MESH_ENABLED) ? self.contents.batch_in_the_future : self.contents.dynamic;
                // smf meshes simply aren't allowed to be batched, or static, so exert your authority over them
                if (entity.etype == ETypes.ENTITY_MESH && guid_get(entity.mesh) && guid_get(entity.mesh).type == MeshTypes.SMF) {
                    list = self.contents.dynamic;
                }
                
                ds_list_add(list, entity);
            }
        } else {
            selection_delete(entity);
        }
    };
    
    static AddOffGrid = function(entity, x = entity.xx, y = entity.yy, z = entity.zz) {
        entity.xx = x;
        entity.yy = y;
        entity.zz = z;
        
        ds_list_add(self.contents.all_entities, entity);
        var list = (entity.batchable && MAP_BATCH_MESH_ENABLED) ? self.contents.batch_in_the_future : self.contents.dynamic;
        // smf meshes simply aren't allowed to be batched, or static, so exert your authority over them
        if (entity.etype == ETypes.ENTITY_MESH && guid_get(entity.mesh) && guid_get(entity.mesh).type == MeshTypes.SMF) {
            list = self.contents.dynamic;
        }
                
        ds_list_add(list, entity);
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
        var result = (what && what.etype == ETypes.ENTITY_MESH_AUTO && what.modification != Modifications.REMOVE);
        
        if (z < self.zz - 1) {
            // check the cell above you for a tile, because tiles kinda appear to
            // exist on the layer below where they actually are
            what = self.contents.map_grid[x][y][z + 1][MapCellContents.MESH];
            result |= (what && what.etype == ETypes.ENTITY_MESH_AUTO && what.modification != Modifications.REMOVE);
        }
        
        return result;
    };
    
    static GetFlag = function(x, y, z) {
        return self.grid_flags[x][y][z];
    };
    
    static SetFlag = function(x, y, z, flag) {
        self.grid_flags[@ x][@ y][@ z] = flag;
    };
    
    static SetSize = function(x, y, z) {
        self.xx = x;
        self.yy = y;
        self.zz = z;
        array_resize_3d(self.grid_flags, x, y, z);
        
        if (self.contents) {
            for (var i = 0; i < ds_list_size(self.contents.all_entities); i++) {
                var thing = self.contents.all_entities[| i];
                if (thing.xx >= xx || thing.yy >= yy || thing.zz >= zz) {
                    selection_delete(thing);
                }
            }
            
            Stuff.graphics.RecreateGrids();
            array_resize_4d(self.contents.map_grid, x, y, z, MapCellContents._COUNT);
        }
        
        if (Game.meta.start.map == self.GUID) {
            Game.meta.start.x = min(Game.meta.start.x, x - 1);
            Game.meta.start.y = min(Game.meta.start.y, y - 1);
            Game.meta.start.z = min(Game.meta.start.z, z - 1);
        }
        
        Stuff.map.ui.SearchID("ENTITY POSITION X").SetRealNumberBounds(0, x - 1);
        Stuff.map.ui.SearchID("ENTITY POSITION Y").SetRealNumberBounds(0, y - 1);
        Stuff.map.ui.SearchID("ENTITY POSITION Z").SetRealNumberBounds(0, z - 1);
    };
    
    static Move = function(entity, x, y, z, mark_changed = true) {
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
    
    static Load = function() {
        if (Stuff.map.active_map) Stuff.map.active_map.Close();
        Stuff.map.active_map = self;
        
        self.contents = new MapContents(self);
        
        Stuff.graphics.RecreateGrids();
        
        var directory = self.directory + "/" + string_replace(self.GUID, ":", "_") + "/";
        
        // these are several reasons this may not work, such as the map having
        // just been created, or some of the files having no data
        try {
            #region zones
            var zone_meta = json_parse(buffer_read_file(directory + "zones.json"));
            for (var i = 0; i < array_length(zone_meta.zones); i++) {
                var zone_data = zone_meta.zones[i];
                array_push(self.contents.all_zones, new global.map_zone_type_objects[zone_data.type](zone_data));
            }
            #endregion
            
            #region batched stuff
            try {
                self.contents.frozen_data = buffer_load(directory + "frozen.vbuff");
                self.contents.frozen = vertex_create_buffer_from_buffer(self.contents.frozen_data, Stuff.graphics.format);
            } catch (e) {
                wtf("Unable to load frozen vertex buffer data - " + self.name);
            }
            
            try {
                self.contents.reflect_frozen_data = buffer_load(directory + "frozen.reflect");
                self.contents.reflect_frozen = vertex_create_buffer_from_buffer(self.contents.reflect_frozen_data, Stuff.graphics.format);
            } catch (e) {
                wtf("Unable to load frozen reflection buffer data - " + self.name);
            }
            
            try {
                self.contents.water_data = buffer_load(directory + "water.vbuff");
                self.contents.water = vertex_create_buffer_from_buffer(self.contents.water_data, Stuff.graphics.format);
            } catch (e) {
                wtf("Unable to load water buffer data - " + self.name);
            }
            #endregion
            
            #region entities
            var entity_data = json_parse(buffer_read_file(directory + "entities.ass"));
            for (var i = 0; i < array_length(entity_data.entities); i++) {
                var ref_data = entity_data.entities[i];
                var entity = new global.etype_meta[ref_data.type].constructor(ref_data);
                self.Add(entity, entity.xx, entity.yy, entity.zz);
            }
            #endregion
        } catch (e) {
            
        }
        
        Stuff.map.ui.Refresh();
    };
    
    static SaveUnloaded = function(directory) {
        var new_directory = directory + "/" + string_replace(self.GUID, ":", "_") + "/";
        var old_directory = self.directory + "/" + string_replace(self.GUID, ":", "_") + "/";
        if (!directory_exists(old_directory)) return;
        if (new_directory != old_directory) {
            directory_destroy(new_directory);
            directory_create(new_directory);
            
            var file = file_find_first(old_directory + "*.*", 0);
            while (file_exists(old_directory + file)) {
                file_copy(old_directory + file, new_directory + file);
                file = file_find_next();
            }
            file_find_close();
        }
    };
    
    self.Export = function(buffer) {
        self.ExportBase(buffer);
        buffer_write(buffer, buffer_u32, self.xx);
        buffer_write(buffer, buffer_u32, self.yy);
        buffer_write(buffer, buffer_u32, self.zz);
        
        buffer_write(buffer, buffer_u32, self.export.index);
        buffer_write(buffer, buffer_u64, self.export.address);
        buffer_write(buffer, buffer_u64, self.export.size);
        
        buffer_write(buffer, buffer_datatype, self.tileset);
        buffer_write(buffer, buffer_datatype, self.water_texture);
        buffer_write(buffer, buffer_f32, self.fog_start);
        buffer_write(buffer, buffer_f32, self.fog_end);
        buffer_write(buffer, buffer_u32, self.fog_colour);
        buffer_write(buffer, buffer_u32, self.base_encounter_rate);
        buffer_write(buffer, buffer_u32, self.base_encounter_deviation);
        buffer_write(buffer, buffer_f32, self.water_level);
        buffer_write(buffer, buffer_u32, self.light_ambient_colour);
        buffer_write(buffer, buffer_datatype, self.skybox);
        buffer_write(buffer, buffer_u16, self.chunk_size);
        buffer_write(buffer, buffer_u32, self.discovery);
        buffer_write(buffer, buffer_string, self.code);
        
        buffer_write(buffer, buffer_u8, array_length(self.lights));
        for (var i = 0; i < array_length(self.lights); i++) {
            buffer_write(buffer, buffer_datatype, self.lights[i]);
        }
        
        buffer_write(buffer, buffer_field, pack(
            self.indoors,
            self.draw_water,
            self.fast_travel_to,
            self.fast_travel_from,
            self.fog_enabled,
            self.on_grid,
            self.reflections_enabled,
            self.light_player_enabled,
            self.light_enabled,
        ));
        
        buffer_write(buffer, buffer_u16, array_length(self.generic_data));
        for (var i = 0; i < array_length(self.generic_data); i++) {
            var data = self.generic_data[i];
            buffer_write(buffer, buffer_string, data.name);
            buffer_write(buffer, buffer_u8, data.type);
            buffer_write(buffer, Stuff.data_type_meta[data.type].buffer_type, data.value);
        }
        
        buffer_write(buffer, buffer_datatype, self.terrain.id);
        buffer_write(buffer, buffer_f32, self.terrain.scale);
    };
    
    static GetFusedChunks = function(chunk_size, max_x, max_y) {
        static chunk_buffer = function(records, buffer, chunk_size, max_x, max_y, buffer_name) {
            static master_chunk_class = function(coords) constructor {
                self.coords = coords;
                self.frozen = -1;
                self.reflect = -1;
                self.water = -1;
            };
            
            var chunks = vertex_buffer_as_chunks(buffer, chunk_size * TILE_WIDTH, max_x, max_y);
            var keys = variable_struct_get_names(chunks);
            for (var i = 0, n = array_length(keys); i < n; i++) {
                var chunk = chunks[$ keys[i]];
                
                var master_chunk = records[$ keys[i]];
                if (!master_chunk) {
                    master_chunk = new master_chunk_class(chunk.coords);
                    records[$ keys[i]] = master_chunk;
                }
                
                master_chunk[$ buffer_name] = chunk.buffer;
            }
        }
        
        var records = { };
        
        if (self.contents.frozen_data) chunk_buffer(records, self.contents.frozen_data, chunk_size, max_x, max_y, "frozen");
        if (self.contents.reflect_frozen_data) chunk_buffer(records, self.contents.reflect_frozen_data, chunk_size, max_x, max_y, "reflect");
        if (self.contents.water_data) chunk_buffer(records, self.contents.water_data, chunk_size, max_x, max_y, "water");
        
        return records;
    };
    
    self.ExportMapContents = function(buffer, index) {
        if (!self.contents) self.Load();
        
        self.export.index = index;
        self.export.address = buffer_tell(buffer);
        
        #region flags
        for (var i = 0; i < self.xx; i++) {
            for (var j = 0; j < self.yy; j++) {
                for (var k = 0; k < self.zz; k++) {
                    buffer_write(buffer, buffer_flag, self.GetFlag(i, j, k));
                }
            }
        }
        #endregion
        
        #region frozen chunks
        var chunks = self.GetFusedChunks(self.chunk_size, (self.xx div Game.meta.grid.chunk_size) - 1, (self.yy div Game.meta.grid.chunk_size) - 1);
        var keys = variable_struct_get_names(chunks);
        buffer_write(buffer, buffer_u32, array_length(keys));
        
        for (var i = 0, n = array_length(keys); i < n; i++) {
            var chunk = chunks[$ keys[i]];
            buffer_write(buffer, buffer_u32, chunk.coords.x);
            buffer_write(buffer, buffer_u32, chunk.coords.y);
            
            buffer_write(buffer, buffer_bool, chunk.frozen != -1);
            if (chunk.frozen != -1) {
                buffer_write_vertex_buffer(buffer, chunk.frozen);
                buffer_delete(chunk.frozen);
            }
            
            buffer_write(buffer, buffer_bool, chunk.reflect != -1);
            if (chunk.reflect != -1) {
                buffer_write_vertex_buffer(buffer, chunk.reflect);
                buffer_delete(chunk.reflect);
            }
            
            buffer_write(buffer, buffer_bool, chunk.water != -1);
            if (chunk.water != -1) {
                buffer_write_vertex_buffer(buffer, chunk.water);
                buffer_delete(chunk.water);
            }
        }
        #endregion
        
        #region batch static objects in the map into chunks
        var exported = batch_all_export(self, self.chunk_size);
        buffer_write(buffer, buffer_u32, array_length(exported));
        
        for (var i = 0, n = array_length(exported); i < n; i++) {
            var chunk = exported[i];
            buffer_write(buffer, buffer_u16, chunk.key >> 24);
            buffer_write(buffer, buffer_u16, chunk.key & 0xffffff);
            
            buffer_write(buffer, buffer_bool, chunk.raw != -1);
            if (chunk.raw != -1) {
                buffer_write_vertex_buffer(buffer, chunk.raw);
            }
            vertex_delete_buffer(chunk.raw);
            
            buffer_write(buffer, buffer_bool, chunk.raw_reflected != -1);
            if (chunk.raw_reflected != -1) {
                buffer_write_vertex_buffer(buffer, chunk.raw_reflected);
            }
            vertex_delete_buffer(chunk.raw_reflected);
        }
        #endregion
        
        #region zones
        buffer_write(buffer, buffer_u32, array_length(self.contents.all_zones));
        for (var i = 0, n = array_length(self.contents.all_zones); i < n; i++) {
            var zone = self.contents.all_zones[i];
            zone.Export(buffer);
        }
        #endregion
        
        #region entities
        var count_addr = buffer_tell(buffer);
        buffer_write(buffer, buffer_u32, 0);
        var exported_entities = 0;
        for (var i = 0; i < ds_list_size(self.contents.all_entities); i++) {
            exported_entities += self.contents.all_entities[| i].Export(buffer);
        }
        buffer_poke(buffer, count_addr, buffer_u32, exported_entities);
        #endregion
        
        self.export.size = buffer_tell(buffer) - self.export.address;
        
        wtf("   Map \"" + self.name + "\" saved to file index " + string(self.export.index) + " at address " + string(self.export.address) + " (" + string(self.export.size) + " bytes)");
    };
    
    static SaveAsset = function(directory) {
        if (!self.contents) {
            self.SaveUnloaded(directory);
            return;
        }
        directory += "/" + string_replace(self.GUID, ":", "_") + "/";
        if (!directory_exists(directory)) directory_create(directory);
        
        #region zones
        var zone_meta = {
            zones: array_create(array_length(self.contents.all_zones)),
        }
        for (var i = 0, n = array_length(self.contents.all_zones); i < n; i++) {
            zone_meta.zones[i] = self.contents.all_zones[i].CreateJSON();
        }
        buffer_write_file(json_stringify(zone_meta), directory + "zones.json");
        #endregion
        
        #region entities
        var entity_data = {
            entities: array_create(ds_list_size(self.contents.all_entities)),
        };
        for (var i = 0, n = ds_list_size(self.contents.all_entities); i < n; i++) {
            entity_data.entities[i] = self.contents.all_entities[| i].CreateJSON(directory);
        }
        buffer_write_file(json_stringify(entity_data), directory + "entities.ass");
        #endregion
        
        #region batched stuff
        if (self.contents.frozen_data) {
            buffer_save(self.contents.frozen_data, directory + "frozen.vbuff");
        }
        if (self.contents.reflect_frozen_data) {
            buffer_save(self.contents.reflect_frozen_data, directory + "frozen.reflect");
        }
        if (self.contents.water_data) {
            buffer_save(self.contents.water_data, directory + "water.vbuff");
        }
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
        json.water_texture = self.water_texture;
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
        json.lights = self.lights;
        json.light_enabled = self.light_enabled;
        json.light_ambient_colour = self.light_ambient_colour;
        json.light_player_enabled = self.light_player_enabled;
        json.skybox = self.skybox;
        json.chunk_size = self.chunk_size;
        json.discovery = self.discovery;
        json.code = self.code;
        json.generic_data = self.generic_data;
        json.grid_flags = self.grid_flags;
        json.terrain = {
            id: self.terrain.id,
            scale: self.terrain.scale,
        };
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONMap();
    };
    
    static Close = function() {
        if (self.contents) self.contents.Destroy();
        if (self.data_buffer) buffer_delete(self.data_buffer);
        if (self.preview) buffer_delete(self.preview);
        if (self.wpreview) buffer_delete(self.wpreview);
        self.contents = undefined;
    };
    
    static Destroy = function() {
        self.Close();
        array_delete(Game.maps, array_search(Game.maps, self), 1);
    };
    
    #region Editor stuff
    static DrawWater = function(set_lights = true) {
        if (!self.draw_water) return;
        if (!self.contents.water) return;
        if (!Settings.view.water) return;
        
        wireframe_enable(Settings.view.wireframe, 512);
        
        matrix_set(matrix_world, matrix_build_identity());
        var tex = Settings.view.texture ? (self.water_texture == NULL ? -1 : sprite_get_texture(guid_get(self.water_texture).picture, 0)) : -1;
        vertex_submit(self.contents.water, pr_trianglelist, tex);
        wireframe_disable();
    };
    #endregion
    
    if (is_struct(source)) {
        self.SetSize(source.xx, source.yy, source.zz);
        self.tiled_map_id = source.tiled_map_id;
        self.on_grid = source.on_grid;
        self.tileset = source.tileset;
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
        self.discovery = source.discovery;
        self.code = source.code;
        self.generic_data = source.generic_data;
        self.chunk_size = source.chunk_size;
        self.grid_flags = source.grid_flags;
        self.lights = source.lights;
        self.water_texture = source[$ "water_texture"] ?? NULL;
        if (source[$ "terrain"] != undefined) {
            self.terrain.id = source.terrain.id;
            self.terrain.scale = source.terrain.scale;
        }
    }
}