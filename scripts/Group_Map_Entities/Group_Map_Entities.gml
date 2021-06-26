function Entity() constructor {
    self.bullet_id = BulletUserIDCollection.Add(self);
    self.name = "Entity";
    self.etype = ETypes.ENTITY;
    self.ztype = undefined;                                                          // for compatibility with zones, which arent technically entities
    self.etype_flags = 0;
    self.is_component = false;
    
    refid_set(self, refid_generate());
    
    self.tmx_id = 0;
    
    // for fusing all static objects such as ground tiles and houses together,
    // so the computer doesn't waste time drawing every single visible Entity
    // individually
    static batch = null;
    
    // when creating one giant collision shape
    static batch_collision = null;
    
    // for things that don't fit into the above category, including but not limited
    // to NPCs, things that animate, things that move and things that need special shaders
    static render = null;
    
    // files
    static save_script = serialize_save_entity;
    
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
    self.autonomous_movement_route = NULL;
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
    self.modification = Modifications.CREATE;
    
    self.translateable = true;
    self.offsettable = false;
    self.rotateable = false;
    self.scalable = false;
    
    self.slot = MapCellContents.TILE;
    
    enum Modifications {
        NONE,
        CREATE,
        UPDATE,
        REMOVE
    }
    
    // whether you're allowed to stick multiple of these (same type of)
    // objects at in the same cell
    self.coexist = false;
    
    // collision data
    self.cobject = noone;
    
    self.on_select = safc_on_entity;
    self.on_deselect = safc_on_entity_deselect;
    self.on_select_ui = safc_on_entity_ui;
    self.get_bounding_box = entity_bounds_one;
    
    static SetCollisionTransform = function() {
        if (c_object_exists(self.cobject)) {
            c_world_add_object(self.cobject);
            c_object_set_userid(self.cobject, self.bullet_id);
            c_transform_position(self.xx * TILE_WIDTH, self.yy * TILE_HEIGHT, self.zz * TILE_DEPTH);
            c_object_apply_transform(self.cobject);
            c_transform_identity();
        }
    };
    
    static SetStatic = function(state) {
        return false;
    };
    
    static SaveAsset = function(directory) {
        directory = self.GetSaveAssetName(directory);
        buffer_write_file(json_stringify(self.CreateJSON()), directory);
    };
    
    static LoadJSONBase = function(source) {
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
    };
    
    static LoadJSON = function(source) {
        self.LoadJSONBase(source);
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
        
        if (self.cobject) {
            // it turns out removing these things is REALLY SLOW, so instead
            // we'll pool them to be removed in an orderly manner (and nullify
            // their masks so they don't accidentally trigger interactions if
            // you click on them)
            c_object_set_mask(self.cobject, 0, 0);
            c_object_set_userid(self.cobject, 0);
            ds_queue_enqueue(Stuff.c_object_cache, self.cobject);
        }
    };
    
    static Destroy = function() {
        self.DestroyBase();
    };
}

function EntityEffect() : Entity() constructor {
    static save_script = serialize_save_entity_effect;

    self.name = "Effect";
    self.etype = ETypes.ENTITY_EFFECT;
    self.etype_flags = ETypeFlags.ENTITY_EFFECT;
    
    // editor properties
    self.slot = MapCellContents.EFFECT;
    self.batchable = false;
    static render = render_effect;
    static on_select = safc_on_effect;
    static on_deselect = safc_on_effect_deselect;
    static on_select_ui = safc_on_effect_ui;
    
    // components
    self.com_light = undefined;
    self.com_particle = undefined;
    self.com_audio = undefined;
    
    static LoadJSONEffect = function(source) {
        self.LoadJSONBase(source);
        var light = source.com.light;
        var particle = source.com.particle;
        var audio = source.com.audio;
        self.com_light = light ? (new global.light_type_constructors[light.type](self, light)) : undefined;
        self.com_particle = particle ? (new ComponentParticle(self, particle)) : undefined;
        self.com_audio = audio ? (new ComponentAudio(self, audio)) : undefined;
    };
    
    static LoadJSON = function(source) {
        self.LoadJSONEffect(source);
    };
    
    static CreateJSONEffect = function() {
        var json = self.CreateJSONBase();
        json.effects = {
            com: {
                light: self.com_light ? self.com_light.CreateJSON() : undefined,
                particle: self.com_particle ? self.com_particle.CreateJSON() : undefined,
                audio: self.com_audio ? self.com_audio.CreateJSON() : undefined,
            },
        };
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONEffect();
    };
    // editor garbage
    self.cobject_x_axis = new EditorComponentAxis(self, c_object_create_cached(Stuff.graphics.c_shape_axis_x, 0, 0), CollisionSpecialValues.TRANSLATE_X);
    self.cobject_y_axis = new EditorComponentAxis(self, c_object_create_cached(Stuff.graphics.c_shape_axis_y, 0, 0), CollisionSpecialValues.TRANSLATE_Y);
    self.cobject_z_axis = new EditorComponentAxis(self, c_object_create_cached(Stuff.graphics.c_shape_axis_z, 0, 0), CollisionSpecialValues.TRANSLATE_Z);
    self.cobject_x_plane = new EditorComponentAxis(self, c_object_create_cached(Stuff.graphics.c_shape_axis_x_plane, 0, 0), CollisionSpecialValues.TRANSLATE_X);
    self.cobject_y_plane = new EditorComponentAxis(self, c_object_create_cached(Stuff.graphics.c_shape_axis_y_plane, 0, 0), CollisionSpecialValues.TRANSLATE_Y);
    self.cobject_z_plane = new EditorComponentAxis(self, c_object_create_cached(Stuff.graphics.c_shape_axis_z_plane, 0, 0), CollisionSpecialValues.TRANSLATE_Z);
    self.axis_over = CollisionSpecialValues.NONE;
    
    static DestroyEffect = function() {
        var map = Stuff.map.active_map;
        var map_contents = map.contents;
        
        var light_index = array_search(map.lights, self.REFID);
        if (light_index != -1) {
            map.lights[@ light_index] = NULL;
        }
        
        self.cobject_x_axis.Destroy();
        self.cobject_y_axis.Destroy();
        self.cobject_z_axis.Destroy();
        self.cobject_x_plane.Destroy();
        self.cobject_y_plane.Destroy();
        self.cobject_z_plane.Destroy();
    };
    
    static Destroy = function() {
        self.DestroyBase();
        self.DestroyEffect();
    };
}

function EntityMesh(mesh) : Entity() constructor {
    self.name = mesh.name;
    
    save_script = serialize_save_entity_mesh;

    self.etype = ETypes.ENTITY_MESH;
    self.etype_flags = ETypeFlags.ENTITY_MESH;
    
    self.is_static = true;
    
    self.mesh = mesh.GUID;
    self.mesh_submesh = mesh.first_proto_guid;                                  // proto-GUID
    self.animated = false;
    self.animation_index = 0;
    self.animation_type = 0;                                                    // if smf ever gets re-added, it the loop type would be stored in here
    self.animation_speed = 0;
    self.animation_end_action = AnimationEndActions.LOOP;
    
    // editor properties
    self.slot = MapCellContents.MESH;
    self.rotateable = true;
    self.offsettable = true;
    self.scalable = true;
    
    static batch = batch_mesh;
    static batch_collision = batch_collision_mesh;
    static render = render_mesh;
    static on_select_ui = safc_on_mesh_ui;
    static get_bounding_box = entity_bounds_mesh;
    
    static SetStatic = function(state) {
        // Meshes with no mesh are not allowed to be marked as static
        if (!guid_get(mesh)) return false;
        if (state != is_static) {
            is_static = state;
            Stuff.map.active_map.contents.population_static = Stuff.map.active_map.contents.population_static + (is_static ? 1 : -1);
        }
    };
    
    switch (mesh.type) {
        case MeshTypes.RAW:
            self.cobject = c_object_create_cached(mesh.cshape, CollisionMasks.MAIN, CollisionMasks.MAIN);
            break;
        case MeshTypes.SMF:
            self.is_static = false;
            self.batchable = false;
            self.SetStatic = function(state) { };
            break;
    }
    
    static GetBuffer = function() {
        // the lookup for an entity's exact mesh is now somewhat complicated, so this
        // script is here to make yoru life easier
        var mesh_data = guid_get(mesh);
        if (!mesh_data) return undefined;
        if (proto_guid_get(mesh_data, mesh_submesh) == undefined) return undefined;
        return mesh_data ? mesh_data.submeshes[proto_guid_get(mesh_data, mesh_submesh)].buffer : undefined;
    };
    
    static GetVertexBuffer = function() {
        // the lookup for an entity's exact mesh is now somewhat complicated, so this
        // script is here to make yoru life easier
        var mesh_data = guid_get(mesh);
        if (!mesh_data) return undefined;
        if (proto_guid_get(mesh_data, mesh_submesh) == undefined) return undefined;
        return mesh_data ? mesh_data.submeshes[proto_guid_get(mesh_data, mesh_submesh)].vbuffer : undefined;
    };
    
    static GetWireBuffer = function() {
        // the lookup for an entity's exact mesh is now somewhat complicated, so this
        // script is here to make yoru life easier
        var mesh_data = guid_get(mesh);
        if (!mesh_data) return undefined;
        if (proto_guid_get(mesh_data, mesh_submesh) == undefined) return undefined;
        return mesh_data ? mesh_data.submeshes[proto_guid_get(mesh_data, mesh_submesh)].wbuffer : undefined;
    };
    
    static GetReflectBuffer = function() {
        // the lookup for an entity's exact mesh is now somewhat complicated, so this
        // script is here to make yoru life easier
        var mesh_data = guid_get(mesh);
        if (!mesh_data) return undefined;
        if (proto_guid_get(mesh_data, mesh_submesh) == undefined) return undefined;
        return mesh_data ? mesh_data.submeshes[proto_guid_get(mesh_data, mesh_submesh)].reflect_buffer : undefined;
    };
    
    static GetReflectVertexBuffer = function() {
        // the lookup for an entity's exact mesh is now somewhat complicated, so this
        // script is here to make yoru life easier
        var mesh_data = guid_get(mesh);
        if (!mesh_data) return undefined;
        if (proto_guid_get(mesh_data, mesh_submesh) == undefined) return undefined;
        return mesh_data ? mesh_data.submeshes[proto_guid_get(mesh_data, mesh_submesh)].reflect_vbuffer : undefined;
    };
    
    static GetReflectWireBuffer = function() {
        // the lookup for an entity's exact mesh is now somewhat complicated, so this
        // script is here to make yoru life easier
        var mesh_data = guid_get(mesh);
        if (!mesh_data) return undefined;
        if (proto_guid_get(mesh_data, mesh_submesh) == undefined) return undefined;
        return mesh_data ? mesh_data.submeshes[proto_guid_get(mesh_data, mesh_submesh)].reflect_wbuffer : undefined;
    };
    
    static GetTexture = function() {
        // the lookup for an entity's exact mesh is now somewhat complicated, so this
        // script is here to make yoru life easier
        var mesh_data = guid_get(mesh);
        var def_texture = Settings.view.texture ? sprite_get_texture(get_active_tileset().picture, 0) : sprite_get_texture(b_tileset_textureless, 0);
        return (mesh_data && guid_get(mesh_data.tex_base)) ? sprite_get_texture(guid_get(mesh_data.tex_base).picture, 0) : def_texture;
    };
    
    static LoadJSONMesh = function(source) {
        self.LoadJSONBase(source);
        self.mesh = source.mesh.mesh;
        self.mesh_submesh = source.mesh.submesh;
        self.animated = source.mesh.animation.animated;
        self.animation_index = source.mesh.animation.index;
        self.animation_type = source.mesh.animation.type;
        self.animation_speed = source.mesh.animation.speed;
        self.animation_end_action = source.mesh.animation.end_action;
    };
    
    static LoadJSON = function(source) {
        self.LoadJSONMesh(source);
    };
    
    static CreateJSONMesh = function() {
        var json = self.CreateJSONBase();
        json.mesh = {
            mesh: self.mesh,
            submesh: self.mesh_submesh,
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
}

function EntityMeshAutotile() : EntityMesh() constructor {
    self.name = "Terrain";
    self.etype = ETypes.ENTITY_MESH_AUTO;
    self.etype_flags = ETypeFlags.ENTITY_MESH_AUTO;
    
    self.terrain_id = 0;                                                        // mask
    self.terrain_type = MeshAutotileLayers.TOP;                                 // layer
    self.autotile_id = Settings.selection.mesh_autotile_type;                   // autotile asset
    
    static AutotileUniqueIdentifier = function() {
        return self.autotile_id + ":" + string(global.at_map[$ self.terrain_id]) + ":" + string(self.terrain_type);
    };
    
    // editor properties
    self.slot = MapCellContents.MESH;
    self.rotateable = false;
    self.offsettable = false;
    self.scalable = false;
    
    static batch = batch_mesh_autotile;
    static render = render_mesh_autotile;
    static on_select_ui = safc_on_mesh_ui;
    static get_bounding_box = entity_bounds_one;
    
    enum MeshAutotileLayers {
        TOP, VERTICAL, BASE, SLOPE, __COUNT,
    }
    
    self.cobject = c_object_create_cached(Stuff.graphics.c_shape_block, CollisionMasks.MAIN, CollisionMasks.MAIN);
    
    self.is_static = true;
    // these things can't *not* be static
    static SetStatic = function(state) {
        return false;
    };
    
    static LoadJSONMeshAT = function(source) {
        self.LoadJSONBase(source);
        self.terrain_id = source.mesh_at.id;
        self.terrain_type = source.mesh_at.type;
        self.autotile_id = source.mesh_at.autotile_id;
    };
    
    static LoadJSON = function(source) {
        self.LoadJSONMeshAT(source);
    };
    
    static Export = function(buffer) {
        // these don't get exported individually
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
}

function EntityPawn() : Entity() constructor {
    static save_script = serialize_save_entity_pawn;
    
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
    self.cobject = c_object_create_cached(Stuff.graphics.c_shape_block, CollisionMasks.MAIN, CollisionMasks.MAIN);
    
    // there will be other things here probably
    static batch = null;                     // you don't batch pawns
    static render = render_pawn;
    static on_select_ui = safc_on_pawn_ui;
    
    static LoadJSONPawn = function(source) {
        self.LoadJSONBase(source);
        self.map_direction = source.pawn.direction;
        self.overworld_sprite = source.pawn.sprite;
    };
    
    static LoadJSON = function(source) {
        self.LoadJSONPawn(source);
    };
    
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
}

function EntityTile(tile_x, tile_y) : Entity() constructor {
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
    
    // rendering
    var tw = TILE_WIDTH;
    var th = TILE_HEIGHT;
    
    self.vbuffer = undefined;
    self.wbuffer = undefined;
    
    static GenerateVertexBuffers = function() {
        if (self.vbuffer != undefined) vertex_delete_buffer(self.vbuffer);
        if (self.wbuffer != undefined) vertex_delete_buffer(self.wbuffer);
        
        var texture_width = 1 / (TEXTURE_SIZE / Stuff.tile_size);
        var texture_height = 1 / (TEXTURE_SIZE / Stuff.tile_size);
        
        var texx1 = tile.tile_x * texture_width;
        var texy1 = tile.tile_y * texture_height;
        var texx2 = (tile.tile_x + 1) * texture_width;
        var texy2 = (tile.tile_y + 1) * texture_height;
        
        var tw = TILE_WIDTH;
        var th = TILE_HEIGHT;
        
        self.vbuffer = vertex_create_buffer();
        vertex_begin(self.vbuffer, Stuff.graphics.vertex_format);
        vertex_point_complete(self.vbuffer, 0, 0, 0, 0, 0, 1, texx1, texy1, tile.tile_color, tile.tile_alpha);
        vertex_point_complete(self.vbuffer, tw, 0, 0, 0, 0, 1, texx2, texy1, tile.tile_color, tile.tile_alpha);
        vertex_point_complete(self.vbuffer, tw, th, 0, 0, 0, 1, texx2, texy2, tile.tile_color, tile.tile_alpha);
        vertex_point_complete(self.vbuffer, tw, th, 0, 0, 0, 1, texx2, texy2, tile.tile_color, tile.tile_alpha);
        vertex_point_complete(self.vbuffer, 0, th, 0, 0, 0, 1, texx1, texy2, tile.tile_color, tile.tile_alpha);
        vertex_point_complete(self.vbuffer, 0, 0, 0, 0, 0, 1, texx1, texy1, tile.tile_color, tile.tile_alpha);
        vertex_end(self.vbuffer);
        
        vertex_begin(self.wbuffer, Stuff.graphics.vertex_format);
        vertex_point_line(self.wbuffer, 0, 0, 0, c_white, 1);
        vertex_point_line(self.wbuffer, tw, 0, 0, c_white, 1);
        vertex_point_line(self.wbuffer, tw, th, 0, c_white, 1);
        vertex_point_line(self.wbuffer, tw, th, 0, c_white, 1);
        vertex_point_line(self.wbuffer, 0, th, 0, c_white, 1);
        vertex_point_line(self.wbuffer, 0, 0, 0, c_white, 1);
        vertex_end(self.wbuffer);
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
    static batch_collision = batch_collision_tile;
    static render = render_tile;
    static on_select_ui = safc_on_tile_ui;
    
    self.cobject = c_object_create_cached(Stuff.graphics.c_shape_tile, CollisionMasks.MAIN, CollisionMasks.MAIN);
    
    static LoadJSONTile = function(source) {
        self.LoadJSONBase(source);
        self.tile_x = source.tile.x;
        self.tile_y = source.tile.y;
        self.tile_color = source.tile.color;
        self.tile_alpha = source.tile.alpha;
    };
    
    static LoadJSON = function(source) {
        self.LoadJSONTile(source);
    };
    
    static Export = function(buffer) {
        // these don't get exported individually
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
        vertex_delete_buffer(self.wbuffer);
    };
    
    static Destroy = function() {
        self.DestroyTile();
    };
}

function EntityTileAnimated() : EntityTile(0, 0) constructor {
    self.name = "Animated Tile";
    self.etype = ETypes.ENTITY_TILE_ANIMATED;
    self.etype_flags = ETypeFlags.ENTITY_TILE_ANIMATED;
    
    static batch = batch_autotile;
    
    static on_select_ui = safc_on_tile_animated_ui;
}