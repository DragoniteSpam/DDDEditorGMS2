function Entity(source) constructor {
    self.name = "Entity";
    self.etype = ETypes.ENTITY;
    self.etype_flags = ETypeFlags.ENTITY;
    self.ztype = undefined;                                                     // for compatibility with zones, which arent technically entities
    self.is_component = false;
    
    refid_set(self, refid_generate());
    
    self.tmx_id = 0;
    
    // for fusing all static objects such as ground tiles and houses together,
    // so the computer doesn't waste time drawing every single visible Entity
    // individually
    static batch = null;
    
    // for things that don't fit into the above category, including but not limited
    // to NPCs, things that animate, things that move and things that need special shaders
    static render = null;
    
    // you can have scripts that do both, if you want to have a static thing that
    // sparkles or something
    
    // serialize
    self.xx = 0;
    self.yy = 0;
    self.zz = 0;
    self.off_xx = 0;
    self.off_yy = 0;
    self.off_zz = 0;
    self.rot_xx = 0;
    self.rot_yy = 0;
    self.rot_zz = 0;
    self.scale_xx = 1;
    self.scale_yy = 1;
    self.scale_zz = 1;
    self.object_events = [];                                                    // i'm imposing a hard limit of 10 of these
    self.switches = array_create(BASE_SELF_VARIABLES, 0);
    self.variables = array_create(BASE_SELF_VARIABLES, 0);
    self.generic_data = [];
    self.is_static = false;
    
    // options
    self.direction_fix = true;
    self.always_update = false;
    self.preserve_on_save = false;
    self.reflect = false;
    self.slope = ATMask.NONE;
    
    // autonomous movement - only useful for things not marked as "static"
    self.autonomous_movement = AutonomousMovementTypes.FIXED;
    self.autonomous_movement_speed = 3;                                         // 0: 0.125, 1: 0.25, 2: 0.5, 3: 1, 4: 2, 5: 4
    self.autonomous_movement_frequency = 2;                                     // 0 through 4
    self.autonomous_movement_route = 0;
    self.movement_routes = [];
    
    enum AutonomousMovementTypes {
        FIXED,
        RANDOM,
        APPROACH,
        CUSTOM
    }
    
    // these are a formality
    self.target_xx = self.xx;
    self.target_yy = self.yy;
    self.target_zz = self.zz;
    self.previous_xx = self.xx;
    self.previous_yy = self.yy;
    self.previous_zz = self.zz;
    
    // editor properties
    
    // the game will know in advance whether something is to be batched or not.
    // the editor may chance this on the fly. remember to override this in dynamic entities.
    self.batchable = true;
    self.batch_addr = undefined;                // pointer to a batch struct
    self.modification = Modifications.NONE;
    
    self.translateable = true;
    self.offsettable = false;
    self.rotateable = false;
    self.scalable = false;
    
    self.slot = MapCellContents.TILE;
    
    enum Modifications {
        NONE,
        UPDATE,
        REMOVE
    }
    
    // whether you're allowed to stick multiple of these (same type of)
    // objects at in the same cell
    self.coexist = false;
    
    self.get_bounding_box = function() {
        return new BoundingBox(self.xx, self.yy, self.zz, self.xx + 1, self.yy + 1, self.zz + 1);
    };
    
    static SetStatic = function(state) {
        return false;
    };
    
    static SaveAsset = function(directory) {
        directory = self.GetSaveAssetName(directory);
        buffer_write_file(json_stringify(self.CreateJSON()), directory);
    };
    
    self.ExportBase = function(buffer) {
        if (self.is_static) return false;
        
        buffer_write(buffer, buffer_u32, self.etype);
        buffer_write(buffer, buffer_string, self.name);
        buffer_write(buffer, buffer_u32, self.xx);
        buffer_write(buffer, buffer_u32, self.yy);
        buffer_write(buffer, buffer_u32, self.zz);
        buffer_write(buffer, buffer_datatype, self.REFID);
        
        buffer_write(buffer, buffer_field, pack(
            self.preserve_on_save,
            self.reflect,
            self.direction_fix,
            self.always_update,
        ));
        
        buffer_write(buffer, buffer_u8, array_length(self.object_events));
        for (var i = 0; i < array_length(self.object_events); i++) {
            self.object_events[i].Export(buffer);
        }
        
        buffer_write(buffer, buffer_f32, self.off_xx);
        buffer_write(buffer, buffer_f32, self.off_yy);
        buffer_write(buffer, buffer_f32, self.off_zz);
        buffer_write(buffer, buffer_f32, self.rot_xx);
        buffer_write(buffer, buffer_f32, self.rot_yy);
        buffer_write(buffer, buffer_f32, self.rot_zz);
        buffer_write(buffer, buffer_f32, self.scale_xx);
        buffer_write(buffer, buffer_f32, self.scale_yy);
        buffer_write(buffer, buffer_f32, self.scale_zz);
        
        buffer_write(buffer, buffer_u8, self.autonomous_movement);
        buffer_write(buffer, buffer_u8, self.autonomous_movement_speed);
        buffer_write(buffer, buffer_u8, self.autonomous_movement_frequency);
        buffer_write(buffer, buffer_u8, self.autonomous_movement_route);
        
        buffer_write(buffer, buffer_u32, array_length(self.movement_routes));
        for (var i = 0; i < array_length(self.movement_routes); i++) {
            self.movement_routes[i].Export(buffer);
        }
        
        buffer_write(buffer, buffer_u8, array_length(self.switches));
        for (var i = 0; i < array_length(self.switches); i++) {
            buffer_write(buffer, buffer_bool, self.switches[i]);
        }
        
        buffer_write(buffer, buffer_u8, array_length(self.variables));
        for (var i = 0; i < array_length(self.variables); i++) {
            buffer_write(buffer, buffer_f32, self.variables[i]);
        }
        
        buffer_write(buffer, buffer_u16, array_length(self.generic_data));
        for (var i = 0; i < array_length(self.generic_data); i++) {
            var data = self.generic_data[i];
            buffer_write(buffer, buffer_string, data.name);
            buffer_write(buffer, buffer_u8, data.type);
            buffer_write(buffer, Stuff.data_type_meta[data.type].buffer_type, data.value);
        }
        
        buffer_write(buffer, buffer_u8, self.slope);
        
        return true;
    };
    
    static CreateJSONBase = function() {
        return {
            name: self.name,
            type: self.etype,
            refid: self.REFID,
            position: {
                x: self.xx,
                y: self.yy,
                z: self.zz,
            },
            offset: {
                x: self.off_xx,
                y: self.off_yy,
                z: self.off_zz,
            },
            rotation: {
                x: self.rot_xx,
                y: self.rot_yy,
                z: self.rot_zz,
            },
            scale: {
                x: self.scale_xx,
                y: self.scale_yy,
                z: self.scale_zz,
            },
            switches: self.switches,
            variables: self.variables,
            generic_data: self.generic_data,
            events: self.object_events,
            options: {
                direction_fix: self.direction_fix,
                always_update: self.always_update,
                preserve: self.preserve_on_save,
                reflect: self.reflect,
                slope: self.slope,
                is_static: self.is_static,
            },
            autonomous: {
                type: self.autonomous_movement,
                speed: self.autonomous_movement_speed,
                frequency: self.autonomous_movement_frequency,
                route: self.autonomous_movement_route,
                routes: self.movement_routes,
            },
            tmx_id: self.tmx_id,
        };
    };
    
    static CreateJSON = function() {
        return self.CreateJSONBase();
    };
    
    static GetSaveAssetName = function(directory) {
        return directory + string_replace_all(self.REFID, ":", "_") + ".ass";
    };
    
    static DestroyBase = function() {
        refid_remove(self);
    };
    
    static Destroy = function() {
        self.DestroyBase();
    };
    
    static GetTransform = function() {
        return matrix_build(
            (self.xx + self.off_xx) * TILE_WIDTH,
            (self.yy + self.off_yy) * TILE_HEIGHT,
            (self.zz + self.off_zz) * TILE_DEPTH,
            self.rot_xx, self.rot_yy, self.rot_zz,
            self.scale_xx, self.scale_yy, self.scale_zz
        );
    };
    
    static GetTransformReflected = function() {
        var water = Stuff.map.active_map.water_level;
        return matrix_build(
            (self.xx + self.off_xx) * TILE_WIDTH,
            (self.yy + self.off_yy) * TILE_HEIGHT,
            (water - (self.zz + self.off_zz - water)) * TILE_DEPTH,
            self.rot_xx, self.rot_yy, self.rot_zz,
            self.scale_xx, self.scale_yy, self.scale_zz
        );
    };
    
    if (is_struct(source)) {
        self.name = source.name;
        refid_set(self, source.refid);
        self.xx = source.position.x;
        self.yy = source.position.y;
        self.zz = source.position.z;
        self.off_xx = source.offset.x;
        self.off_yy = source.offset.y;
        self.off_zz = source.offset.z;
        self.rot_xx = source.rotation.x;
        self.rot_yy = source.rotation.y;
        self.rot_zz = source.rotation.z;
        self.scale_xx = source.scale.x;
        self.scale_yy = source.scale.y;
        self.scale_zz = source.scale.z;
        self.switches = source.switches;
        self.variables = source.variables;
        self.generic_data = source.generic_data;
        self.object_events = source.events;
        self.direction_fix = source.options.direction_fix;
        self.always_update = source.options.always_update;
        self.preserve_on_save = source.options.preserve;
        self.reflect = source.options.reflect;
        self.slope = source.options.slope;
        self.is_static = source.options.is_static;
        self.autonomous_movement = source.autonomous.type;
        self.autonomous_movement_speed = source.autonomous.speed;
        self.autonomous_movement_frequency = source.autonomous.frequency;
        self.autonomous_movement_route = source.autonomous.route;
        self.movement_routes = source.autonomous.routes;
        self.tmx_id = source.tmx_id;
        
        // we changed the name of this variable in the update
        for (var i = 0, n = array_length(self.generic_data); i < n; i++) {
            var gen = self.generic_data[i];
            if (variable_struct_exists(gen, "value_type_guid")) {
                gen.type_guid = gen.value_type_guid;
            }
            if (variable_struct_exists(gen, "value_data")) {
                gen.value = gen.value_data;
            }
        }
        
        if (!is_numeric(self.autonomous_movement_route)) self.autonomous_movement_route = 0;
        
        for (var i = 0; i < array_length(self.movement_routes); i++) {
            self.movement_routes[i] = new MoveRoute(self.movement_routes[i]);
        }
        
        for (var i = 0; i < array_length(self.object_events); i++) {
            self.object_events[i] = new InstantiatedEvent(self.object_events[i]);
        }
    } else {
        self.name = source;
    }
}

function EntityEffect(source) : Entity(source) constructor {
    self.name = "Effect";
    self.etype = ETypes.ENTITY_EFFECT;
    self.etype_flags = ETypeFlags.ENTITY_EFFECT;
    
    // editor properties
    self.slot = MapCellContents.EFFECT;
    self.batchable = false;
    
    static render = function() {
        var mode = Stuff.map;
        var camera = camera_get_active();
        var com_offset = 18;
        
        var world_x = (self.xx + self.off_xx) * TILE_WIDTH;
        var world_y = (self.yy + self.off_yy) * TILE_HEIGHT;
        var world_z = (self.zz + self.off_zz) * TILE_DEPTH;
        
        var position = mode.camera.GetScreenSpace(world_x, world_y, world_z);
        var dist = mode.camera.DistanceTo(world_x, world_y, world_z);
        var f = min(dist / 160, 2.5);
        Stuff.graphics.DrawAxesTranslation(world_x, world_y, world_z, 0, 0, 0, f, f, f);
        
        render_effect_add_sprite(spr_star, position, new Vector2(0, 0));
        
        if (self.com_light) {
            render_effect_add_sprite(self.com_light.sprite, position, new Vector2(-com_offset, com_offset));
            self.com_light.Render();
        }
        if (self.com_particle) {
            render_effect_add_sprite(self.com_particle.sprite, position, new Vector2(0, com_offset));
            self.com_particle.Render();
        }
        if (self.com_audio) {
            render_effect_add_sprite(self.com_audio.sprite, position, new Vector2(com_offset, com_offset));
            self.com_audio.Render();
        }
    };
    
    // components
    self.com_light = undefined;
    self.com_particle = undefined;
    self.com_audio = undefined;
    self.com_marker = -1;
    
    self.Export = function(buffer) {
        self.ExportBase(buffer);
        if (self.com_light) {
            self.com_light.Export(buffer);
        } else {
            buffer_write(buffer, buffer_u8, LightTypes.NONE);
        }
        
        if (self.com_particle) {
            self.com_particle.Export(buffer);
        } else {
            buffer_write(buffer, buffer_u8, 0);
        }
        
        if (self.com_audio) {
            self.com_audio.Export(buffer);
        } else {
            buffer_write(buffer, buffer_u8, 0);
        }
        buffer_write(buffer, buffer_s32, self.com_marker);
        return 1;
    };
    
    static CreateJSONEffect = function() {
        var json = self.CreateJSONBase();
        json.effects = {
            com: {
                light: self.com_light ? self.com_light.CreateJSON() : undefined,
                particle: self.com_particle ? self.com_particle.CreateJSON() : undefined,
                audio: self.com_audio ? self.com_audio.CreateJSON() : undefined,
                marker: self.com_marker,
            },
        };
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONEffect();
    };
    
    static DestroyEffect = function() {
        var map = Stuff.map.active_map;
        var map_contents = map.contents;
        
        var light_index = array_search(map.lights, self.REFID);
        if (light_index != -1) {
            map.lights[@ light_index] = NULL;
        }
    };
    
    static Destroy = function() {
        self.DestroyBase();
        self.DestroyEffect();
    };
    
    if (is_struct(source)) {
        var light = source.effects.com.light;
        var particle = source.effects.com.particle;
        var audio = source.effects.com.audio;
        /// @todo lame hack undefined in json
        if (light == pointer_null) light = undefined;
        if (particle == pointer_null) particle = undefined;
        if (audio == pointer_null) audio = undefined;
        self.com_light = light ? (new global.light_type_constructors[light.specific.type](self, light)) : undefined;
        self.com_particle = particle ? (new ComponentParticle(self, particle)) : undefined;
        self.com_audio = audio ? (new ComponentAudio(self, audio)) : undefined;
        self.com_marker = source.effects.com[$ "marker"] ?? -1;
    }
}

function EntityMesh(source, mesh) : Entity(source) constructor {
    self.name = mesh ? mesh.name : self.name;
    
    self.etype = ETypes.ENTITY_MESH;
    self.etype_flags = ETypeFlags.ENTITY_MESH;
    
    self.is_static = true;
    
    self.mesh = NULL;
    self.mesh_submesh = NULL;                                                   // proto-GUID
    self.animated = false;
    self.animation_index = 0;
    self.animation_type = 0;                                                    // if smf ever gets re-added, it the loop type would be stored in here
    self.animation_speed = 0;
    self.animation_end_action = AnimationEndActions.LOOP;
    
    // someday it would be nice to make this a Material but i dont have time
    // to do that right now
    self.texture = NULL;                                                        // GUID
    
    // editor properties
    self.slot = MapCellContents.MESH;
    self.rotateable = true;
    self.offsettable = true;
    self.scalable = true;
    
    self.batch = method(self, batch_mesh);
    
    self.render = function(entity) {
        var mesh = guid_get(entity.mesh);
        if (mesh && entity.GetVertexBuffer()) {
            switch (mesh.type) {
                case MeshTypes.RAW:
                    var mesh = guid_get(entity.mesh);
                    matrix_set(matrix_world, matrix_build((entity.xx + entity.off_xx) * TILE_WIDTH, (entity.yy + entity.off_yy) * TILE_HEIGHT, (entity.zz + entity.off_zz) * TILE_DEPTH, entity.rot_xx, entity.rot_yy, entity.rot_zz, entity.scale_xx, entity.scale_yy, entity.scale_zz));
                    var tex = entity.GetTexture();
                    vertex_submit(entity.GetVertexBuffer(), pr_trianglelist, tex);
                    
                    if (Stuff.map.active_map.reflections_enabled) {
                        var water = Stuff.map.active_map.water_level;
                        var offset = (water - (entity.zz + entity.off_zz - water)) * TILE_DEPTH;
                        matrix_set(matrix_world, matrix_build((entity.xx + entity.off_xx) * TILE_WIDTH, (entity.yy + entity.off_yy) * TILE_HEIGHT, offset, entity.rot_xx, entity.rot_yy, entity.rot_zz, entity.scale_xx, entity.scale_yy, entity.scale_zz));
                        
                        var reflect = entity.GetReflectVertexBuffer();
                        if (reflect) {
                            vertex_submit(reflect, pr_trianglelist, tex);
                        }
                    }
                    
                    matrix_set(matrix_world, matrix_build_identity());
                    break;
                case MeshTypes.SMF: break;
            }
        } else {
            matrix_set(matrix_world, matrix_build((entity.xx + entity.off_xx) * TILE_WIDTH, (entity.yy + entity.off_yy) * TILE_HEIGHT, (entity.zz + entity.off_zz) * TILE_DEPTH, entity.rot_xx, entity.rot_yy, entity.rot_zz, entity.scale_xx, entity.scale_yy, entity.scale_zz));
            vertex_submit(Stuff.graphics.mesh_missing, pr_trianglelist, -1);
            matrix_set(matrix_world, matrix_build_identity());
        }
    };
    
    self.get_bounding_box = function() {
        var mesh_data = guid_get(self.mesh);
        return new BoundingBox(self.xx + mesh_data.xmin, self.yy + mesh_data.ymin, self.zz + mesh_data.zmin, self.xx + mesh_data.xmax, self.yy + mesh_data.ymax, self.zz + mesh_data.zmax);
    };
    
    self.SetMesh = function(mesh, submesh = undefined) {
        self.mesh_submesh = NULL;
        self.is_static = false;
        self.batchable = false;
        self.SetStatic = function(state) { };
        
        if (mesh) {
            self.mesh = mesh.GUID;
            switch (mesh.type) {
                case MeshTypes.RAW:
                    self.mesh_submesh = submesh ?? mesh.first_proto_guid;
                    self.is_static = true;
                    self.batchable = true;
                    self.SetStatic = function(state) { self.is_static = state; };
                    break;
                case MeshTypes.SMF:
                    self.mesh_submesh = NULL;
                    self.is_static = false;
                    self.batchable = false;
                    self.SetStatic = function(state) { };
                    break;
            }
        }
    };
    
    self.SetMesh(mesh);
    
    self.GetBuffer = function() {
        // the lookup for an entity's exact mesh is now somewhat complicated, so this
        // script is here to make yoru life easier
        var mesh_data = guid_get(mesh);
        if (!mesh_data) return undefined;
        if (proto_guid_get(mesh_data, self.mesh_submesh) == undefined) return undefined;
        return mesh_data ? mesh_data.submeshes[proto_guid_get(mesh_data, self.mesh_submesh)].buffer : undefined;
    };
    
    self.GetVertexBuffer = function() {
        // the lookup for an entity's exact mesh is now somewhat complicated, so this
        // script is here to make yoru life easier
        var mesh_data = guid_get(self.mesh);
        if (!mesh_data) return undefined;
        if (proto_guid_get(mesh_data, self.mesh_submesh) == undefined) return undefined;
        return mesh_data ? mesh_data.submeshes[proto_guid_get(mesh_data, self.mesh_submesh)].vbuffer : undefined;
    };
    
    self.GetReflectBuffer = function() {
        // the lookup for an entity's exact mesh is now somewhat complicated, so this
        // script is here to make yoru life easier
        var mesh_data = guid_get(mesh);
        if (!mesh_data) return undefined;
        if (proto_guid_get(mesh_data, self.mesh_submesh) == undefined) return undefined;
        return mesh_data ? mesh_data.submeshes[proto_guid_get(mesh_data, self.mesh_submesh)].reflect_buffer : undefined;
    };
    
    self.GetReflectVertexBuffer = function() {
        // the lookup for an entity's exact mesh is now somewhat complicated, so this
        // script is here to make yoru life easier
        var mesh_data = guid_get(mesh);
        if (!mesh_data) return undefined;
        if (proto_guid_get(mesh_data, self.mesh_submesh) == undefined) return undefined;
        return mesh_data ? mesh_data.submeshes[proto_guid_get(mesh_data, self.mesh_submesh)].reflect_vbuffer : undefined;
    };
    
    self.GetTexture = function() {
        var own_texture = guid_get(self.texture);
        if (own_texture) {
            return sprite_get_texture(own_texture.picture, 0);
        }
        
        // the lookup for an entity's exact mesh is now somewhat complicated, so this
        // script is here to make yoru life easier
        var mesh_data = guid_get(self.mesh);
        if (mesh_data && guid_get(mesh_data.tex_base)) {
            return sprite_get_texture(guid_get(mesh_data.tex_base).picture, 0);
        }
        
        return Settings.view.texture ? sprite_get_texture(MAP_ACTIVE_TILESET.picture, 0) : sprite_get_texture(b_tileset_textureless, 0);
    };
    
    self.Export = function(buffer) {
        if (!self.ExportBase(buffer)) return 0;
        buffer_write(buffer, buffer_datatype, self.mesh);
        buffer_write(buffer, buffer_datatype, self.mesh_submesh);
        buffer_write(buffer, buffer_datatype, self.texture);
        buffer_write(buffer, buffer_field, pack(
            self.animated
        ));
        buffer_write(buffer, buffer_u32, self.animation_index);
        buffer_write(buffer, buffer_u8, self.animation_type);
        buffer_write(buffer, buffer_f32, self.animation_speed);
        buffer_write(buffer, buffer_u8, self.animation_end_action);
        
        return 1;
    };
    
    static CreateJSONMesh = function() {
        var json = self.CreateJSONBase();
        json.mesh = {
            mesh: self.mesh,
            submesh: self.mesh_submesh,
            texture: self.texture,
            animation: {
                animated: self.animated,
                index: self.animation_index,
                type: self.animation_type,
                speed: self.animation_speed,
                end_action: self.animation_end_action,
            },
        };
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONMesh();
    };
    
    if (is_struct(source)) {
        self.mesh = source.mesh.mesh;
        self.mesh_submesh = source.mesh.submesh;
        self.texture = source.mesh[$ "texture"] ?? NULL;
        self.animated = source.mesh.animation.animated;
        self.animation_index = source.mesh.animation.index;
        self.animation_type = source.mesh.animation.type;
        self.animation_speed = source.mesh.animation.speed;
        self.animation_end_action = source.mesh.animation.end_action;
    }
}

function EntityMeshAutotile(source) : EntityMesh(source) constructor {
    self.name = "Terrain";
    self.etype = ETypes.ENTITY_MESH_AUTO;
    self.etype_flags = ETypeFlags.ENTITY_MESH_AUTO;
    
    self.terrain_id = 0;                                                        // mask
    self.terrain_type = MeshAutotileLayers.TOP;                                 // layer
    self.autotile_id = Settings.selection.mesh_autotile_type;                   // autotile asset
    
    static AutotileUniqueIdentifier = function() {
        return self.autotile_id + ":" + string(get_index_from_autotile_mask(self.terrain_id)) + ":" + string(self.terrain_type);
    };
    
    // editor properties
    self.slot = MapCellContents.MESH;
    self.rotateable = false;
    self.offsettable = false;
    self.scalable = false;
    
    static batch = batch_mesh_autotile;
    static render = function(mesh_autotile) {
        var mapping = get_index_from_autotile_mask(mesh_autotile.terrain_id);
        
        var at = guid_get(mesh_autotile.autotile_id);
        var vbuffer = at ? at.layers[mesh_autotile.terrain_type].tiles[mapping].vbuffer : Stuff.graphics.missing_autotile;
        if (!vbuffer) vbuffer = Stuff.graphics.missing_autotile;
        
        matrix_set(matrix_world, matrix_build(mesh_autotile.xx * TILE_WIDTH, mesh_autotile.yy * TILE_HEIGHT, mesh_autotile.zz * TILE_DEPTH, 0, 0, 0, 1, 1, 1));
        
        if (Settings.view.entities) {
            var tex = Settings.view.texture ? sprite_get_texture(MAP_ACTIVE_TILESET.picture, 0) : sprite_get_texture(b_tileset_textureless, 0);
            vertex_submit(vbuffer, pr_trianglelist, tex);
        }
        
        matrix_set(matrix_world, matrix_build_identity());
    };
    
    self.get_bounding_box = function() {
        return new BoundingBox(self.xx, self.yy, self.zz, self.xx + 1, self.yy + 1, self.zz + 1);
    };
    
    enum MeshAutotileLayers {
        TOP, VERTICAL, BASE, SLOPE, __COUNT,
    }
    
    self.is_static = true;
    // these things can't *not* be static
    static SetStatic = function(state) { };
    
    self.Export = function(buffer) {
        return 0;
    };
    
    static CreateJSONMeshAT = function() {
        var json = self.CreateJSONMesh();
        json.mesh_at = {
            id: self.terrain_id,
            type: self.terrain_type,
            autotile_id: self.autotile_id,
        };
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONMeshAT();
    };
    
    if (is_struct(source)) {
        self.terrain_id = source.mesh_at.id;
        self.terrain_type = source.mesh_at.type;
        self.autotile_id = source.mesh_at.autotile_id;
    }
}

function EntityPawn(source) : Entity(source) constructor {
    self.overworld_sprite = array_empty(Game.graphics.overworlds) ? NULL : Game.graphics.overworlds[0].GUID;
    self.map_direction = 0;
    
    // not serialized
    self.frame = 0;
    self.is_animating = false;
    
    // other properties - inherited
    self.name = "Pawn";
    self.etype = ETypes.ENTITY_PAWN;
    self.etype_flags = ETypeFlags.ENTITY_PAWN;
    
    self.direction_fix = false;              // because it would be weird to have this off by default
    self.preserve_on_save = true;
    self.reflect = true;
    
    // editor properties
    self.slot = MapCellContents.PAWN;
    self.batchable = false;
    
    // there will be other things here probably
    static batch = null;                     // you don't batch pawns
    static render = function(pawn) {
        if (!Settings.view.entities) return;
        var data = guid_get(self.overworld_sprite);
        data = data ? data : Stuff.default_pawn;
        var spritesheet_height = 4;
        var spritesheet_frames = data ? data.hframes : 4;
    
        if (self.is_animating) {
            self.frame = (self.frame + Settings.config.npc_animate_rate * (delta_time / MILLION)) % spritesheet_frames;
        }
    
        var index = self.map_direction * data.hframes + floor(self.frame);
    
        matrix_set(matrix_world, matrix_build(self.xx * TILE_WIDTH, self.yy * TILE_HEIGHT, self.zz * TILE_DEPTH, 0, 0, 0, 1, 1, 1));
        vertex_submit(data ? data.npc_frames[index] : Stuff.graphics.base_npc, pr_trianglelist, sprite_get_texture(data ? data.picture : spr_pawn_missing, 0));
        matrix_set(matrix_world, matrix_build_identity());
    };
    
    self.Export = function(buffer) {
        self.ExportBase(buffer);
        buffer_write(buffer, buffer_u8, self.map_direction);
        buffer_write(buffer, buffer_datatype, self.overworld_sprite);
        return 1;
    };
    
    // pawns can't be static
    self.is_static = false;
    static SetStatic = function(state) { };
    
    static CreateJSONPawn = function() {
        var json = self.CreateJSONBase();
        json.pawn = {
            direction: self.map_direction,
            sprite: self.overworld_sprite,
        };
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONPawn();
    };
    
    if (is_struct(source)) {
        self.map_direction = source.pawn.direction;
        self.overworld_sprite = source.pawn.sprite;
    }
}

function EntityTile(source, tile_x, tile_y) : Entity(source) constructor {
    self.name = "Tile";
    self.etype = ETypes.ENTITY_TILE;
    self.etype_flags = ETypeFlags.ENTITY_TILE;
    
    // serialize
    self.tile_x = tile_x;
    self.tile_y = tile_y;
    self.tile_color = c_white;
    self.tile_alpha = 1;
    
    // if you want to be really fancy you can use different colors for all four
    // vertices of the tile but I can't think of any practical use for that
    
    self.vbuffer = undefined;
    
    static GenerateVertexBuffers = function() {
        if (self.vbuffer != undefined) vertex_delete_buffer(self.vbuffer);
        
        var texture_width = Stuff.tile_size / TEXTURE_WIDTH;
        var texture_height = Stuff.tile_size / TEXTURE_HEIGHT;
        
        var texx1 = self.tile_x * texture_width;
        var texy1 = self.tile_y * texture_height;
        var texx2 = (self.tile_x + 1) * texture_width;
        var texy2 = (self.tile_y + 1) * texture_height;
        
        var tw = TILE_WIDTH;
        var th = TILE_HEIGHT;
        
        self.vbuffer = vertex_create_buffer();
        vertex_begin(self.vbuffer, Stuff.graphics.format);
        vertex_point_complete(self.vbuffer, 0, 0, 0, 0, 0, 1, texx1, texy1, self.tile_color, self.tile_alpha);
        vertex_point_complete(self.vbuffer, tw, 0, 0, 0, 0, 1, texx2, texy1, self.tile_color, self.tile_alpha);
        vertex_point_complete(self.vbuffer, tw, th, 0, 0, 0, 1, texx2, texy2, self.tile_color, self.tile_alpha);
        vertex_point_complete(self.vbuffer, tw, th, 0, 0, 0, 1, texx2, texy2, self.tile_color, self.tile_alpha);
        vertex_point_complete(self.vbuffer, 0, th, 0, 0, 0, 1, texx1, texy2, self.tile_color, self.tile_alpha);
        vertex_point_complete(self.vbuffer, 0, 0, 0, 0, 0, 1, texx1, texy1, self.tile_color, self.tile_alpha);
        vertex_end(self.vbuffer);
    };
    
    self.GenerateVertexBuffers();
    // other properties
    self.is_static = true;
    // these things can't *not* be static
    static SetStatic = function(state) {
        return false;
    };
    
    // editor properties
    self.slot = MapCellContents.TILE;
    
    static batch = batch_tile;
    static render = function(entity) {
        var xx = tile.xx * TILE_WIDTH;
        var yy = tile.yy * TILE_HEIGHT;
        var zz = tile.zz * TILE_DEPTH;
        
        var ts = MAP_ACTIVE_TILESET;
        
        if (Settings.view.entities) {
            var tex = sprite_get_texture(Settings.view.texture ? ts.picture : b_tileset_textureless, 0);
            matrix_set(matrix_world, matrix_build(xx, yy, zz, 0, 0, 0, 1, 1, 1));
            vertex_submit(tile.vbuffer, pr_trianglelist, tex);
            matrix_set(matrix_world, matrix_build_identity());
        }
    };
    
    self.Export = function(buffer) {
        return 0;
    };
    
    static CreateJSONTile = function() {
        var json = self.CreateJSONBase();
        json.tile = {
            x: self.tile_x,
            y: self.tile_y,
            color: self.tile_color,
            alpha: self.tile_alpha,
        };
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONTile();
    };
    
    static DestroyTile = function() {
        vertex_delete_buffer(self.vbuffer);
    };
    
    static Destroy = function() {
        self.DestroyTile();
    };
    
    if (is_struct(source)) {
        self.tile_x = source.tile.x;
        self.tile_y = source.tile.y;
        self.tile_color = source.tile.color;
        self.tile_alpha = source.tile.alpha;
    }
}

function EntityTileAnimated(source) : EntityTile(source, 0, 0) constructor {
    self.name = "Animated Tile";
    self.etype = ETypes.ENTITY_TILE_ANIMATED;
    self.etype_flags = ETypeFlags.ENTITY_TILE_ANIMATED;
    
    static batch = batch_autotile;
    
    if (is_struct(source)) {
        
    }
}