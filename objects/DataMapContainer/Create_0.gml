/// @description map properties

event_inherited();

name = "Map";
summary = "it does map things";

data_buffer = buffer_create(1, buffer_grow, 1);
contents = noone;
version = DataVersions._CURRENT;

tiled_map_id = -1;

preview = noone;
wpreview = noone;
cspreview = noone;
cpreview = noone;

on_grid = true;

// all of the map properties have finally been moved over to the map container

xx = 64;                                    // dimensions
yy = 64;
zz = 8;

tileset = NULL;                             // GUID
is_3d = true;                               // bool
fog_start = 1024;                           // float
fog_end = 3072;                             // float
fog_enabled = true;                         // bool
fog_colour = c_white;                       // uint
indoors = false;                            // bool
draw_water = true;                          // bool
water_level = 0;                            // float
reflections_enabled = true;                 // bool
fast_travel_to = true;                      // bool
fast_travel_from = true;                    // bool
base_encounter_rate = 8;                    // steps?
base_encounter_deviation = 4;               // ehh
light_enabled = true;                       // bool
light_ambient_colour = c_white;             // uint
light_player_enabled = true;                // bool
skybox = NULL;                              // GUID
map_chunk_size = 32;                        // int

discovery = 0;                              // index

code = Stuff.default_lua_map;               // code

generic_data = ds_list_create();            // similar to that attached to Entities

ds_list_add(Stuff.all_maps, id);

Add = function(entity, x, y, z, is_temp, add_to_lists) {
    if (x == undefined) x = entity.xx;
    if (y == undefined) y = entity.yy;
    if (z == undefined) z = entity.zz;
    if (is_temp == undefined) is_temp = false;
    if (add_to_lists == undefined) add_to_lists = true;
    // Does not check to see if the specified coordinates are in bounds.
    // You are responsible for that.
    
    var cell = contents.map_grid[x][y][z]
    
    // only add thing if the space is not already occupied
    if (!cell[@ entity.slot]) {
        cell[@ entity.slot] = entity;
        
        entity.xx = x;
        entity.yy = y;
        entity.zz = z;
        
        entity.SetCollisionTransform();
        
        if (add_to_lists) {
            ds_list_add(all_entities, entity);
        }
        
        // set that argument to false to avoid adding the instance to a list - this might
        // be because it's a temporary instance, or perhaps it's already in the map and you're
        // just trying to move it
        if (!is_temp && add_to_lists) {
            var list = entity.batchable ? batch_in_the_future : dynamic;
            // smf meshes simply aren't allowed to be batched, or static, so exert your authority over them
            if (instanceof_classic(entity, EntityMesh) && guid_get(entity.mesh) && guid_get(entity.mesh).type == MeshTypes.SMF) {
                list = map.dynamic;
            }
            
            ds_list_add(list, entity);
            entity.listed = true;
            ds_list_add(changes, entity);
        }
    } else {
        safa_delete(entity);
    }
};

FreeAt = function(x, y, z, slot) {
    return !contents.map_grid[x][y][z][slot];
};

Get = function(x, y, z) {
    return contents.map_grid[x][y][z];
};

GetMeshAutotileData = function(x, y, z) {
    if (!is_clamped(x, 0, xx - 1) || !is_clamped(y, 0, yy - 1) || !is_clamped(z, 0, zz - 1)) return false;
    
    var what = contents.map_grid[x][y][z][MapCellContents.MESH];
    var result = (instanceof_classic(what, EntityMeshAutotile) && what.modification != Modifications.REMOVE);
    
    if (z < zz - 1) {
        // check the cell above you for a tile, because tiles kinda appear to
        // exist on the layer below where they actually are
        var what = contents.map_grid[x][y][z + 1][MapCellContents.MESH];
        result = result || (what && what.modification != Modifications.REMOVE);
    }
    
    return result;
};

GetFlag = function(x, y, z) {
    return contents.map_grid_tags[x][y][z];
};

SetFlag = function(x, y, z, flag) {
    contents.map_grid_tags[@ x][@ y][@ z] = flag;
};

Move = function(entity, x, y, z, mark_changed) {
    if (mark_changed == undefined) mark_changed = true;
    
    if (FreeAt(x, y, z, entity.slot)) {
        Remove(entity);
        Add(entity, x, y, z, false, false);
        if (mark_changed) {
            editor_map_mark_changed(entity);
        }
    }
};

Remove = function(entity) {
    var cell = contents.map_grid[entity.xx][entity.yy][entity.zz];
    if (cell[entity.slot] == entity) {
        cell[@ entity.slot] = undefined;
    }
};