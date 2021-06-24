function selection_count() {
    var n = 0;
    
    for (var i = 0; i < ds_list_size(Stuff.map.active_map.contents.all_entities); i++) {
        if (selected(Stuff.map.active_map.contents.all_entities[| i])) {
            if (++n > 1) {
                return SelectionCounts.MULTIPLE;
            }
        }
    }
    
    if (n == 0) {
        return SelectionCounts.NONE;
    }
    
    return SelectionCounts.ONE;
    
    enum SelectionCounts {
        NONE,
        ONE,
        MULTIPLE
    }
}

function selected(entity, mask) {
    if (mask == undefined) mask = Settings.selection.mask;
    
    if (!entity.exist_in_map) return false;
    
    if (entity.etype_flags & mask) {
        for (var i = 0; i < array_length(Stuff.map.selection); i++) {
            if (Stuff.map.selection[i].selected_determination(entity)) {
                return true;
            }
        }
    }
    
    return false;
}

function selected_affected_terrain() {
    // this is O(n). will not scale as well as i'd like. Use with caution.
    var map = Stuff.map.active_map;
    var list = ds_list_create();
    var mask_mesh_auto = ETypeFlags.ENTITY_MESH_AUTO;
    var mask_tile = ETypeFlags.ENTITY_TILE;
    
    for (var i = 0; i < ds_list_size(Stuff.map.active_map.contents.all_entities); i++) {
        var thing = Stuff.map.active_map.contents.all_entities[| i];
        
        if (!instanceof_classic(thing, EntityMeshAutotile)) continue;
        
        if (selected_border(thing)) {
            ds_list_add(list, thing);
        }
        
        // above
        if (map.GetMeshAutotileData(thing.xx, thing.yy, thing.zz + 1)) {
            var neighbor = map.Get(thing.xx, thing.yy, thing.zz + 1);
            var neighbor_mesh = neighbor[@ MapCellContents.MESH];
            var neighbor_tile = neighbor[@ MapCellContents.TILE];
            if (instanceof_classic(neighbor_mesh, EntityMeshAutotile) && selected_border(neighbor_mesh, mask_mesh_auto) ||
                    instanceof_classic(neighbor_tile, EntityTile) && selected_border(neighbor_tile, mask_tile)
                ) {
                ds_list_add(list, thing);
            }
        }
        
        // below
        if (map.GetMeshAutotileData(thing.xx, thing.yy, thing.zz - 1)) {
            var neighbor = map.Get(thing.xx, thing.yy, thing.zz - 1);
            var neighbor_mesh = neighbor[@ MapCellContents.MESH];
            var neighbor_tile = neighbor[@ MapCellContents.TILE];
            if (instanceof_classic(neighbor_mesh, EntityMeshAutotile) && selected_border(neighbor_mesh, mask_mesh_auto) ||
                    instanceof_classic(neighbor_tile, EntityTile) && selected_border(neighbor_tile, mask_tile)
                ) {
                ds_list_add(list, thing);
            }
        }
        
        // north
        if (map.GetMeshAutotileData(thing.xx, thing.yy - 1, thing.zz)) {
            var neighbor = map.Get(thing.xx, thing.yy - 1, thing.zz);
            var neighbor_mesh = neighbor[@ MapCellContents.MESH];
            var neighbor_tile = neighbor[@ MapCellContents.TILE];
            if (instanceof_classic(neighbor_mesh, EntityMeshAutotile) && selected_border(neighbor_mesh, mask_mesh_auto) ||
                    instanceof_classic(neighbor_tile, EntityTile) && selected_border(neighbor_tile, mask_tile)
                ) {
                ds_list_add(list, thing);
            }
        }
        
        // south
        if (map.GetMeshAutotileData(thing.xx, thing.yy + 1, thing.zz)) {
            var neighbor = map.Get(thing.xx, thing.yy + 1, thing.zz);
            var neighbor_mesh = neighbor[@ MapCellContents.MESH];
            var neighbor_tile = neighbor[@ MapCellContents.TILE];
            if (instanceof_classic(neighbor_mesh, EntityMeshAutotile) && selected_border(neighbor_mesh, mask_mesh_auto) ||
                    instanceof_classic(neighbor_tile, EntityTile) && selected_border(neighbor_tile, mask_tile)
                ) {
                ds_list_add(list, thing);
            }
        }
        
        // east
        if (map.GetMeshAutotileData(thing.xx + 1, thing.yy, thing.zz)) {
            var neighbor = map.Get(thing.xx + 1, thing.yy, thing.zz);
            var neighbor_mesh = neighbor[@ MapCellContents.MESH];
            var neighbor_tile = neighbor[@ MapCellContents.TILE];
            if (instanceof_classic(neighbor_mesh, EntityMeshAutotile) && selected_border(neighbor_mesh, mask_mesh_auto) ||
                    instanceof_classic(neighbor_tile, EntityTile) && selected_border(neighbor_tile, mask_tile)
                ) {
                ds_list_add(list, thing);
            }
        }
        
        // west
        if (map.GetMeshAutotileData(thing.xx - 1, thing.yy, thing.zz)) {
            var neighbor = map.Get(thing.xx - 1, thing.yy, thing.zz);
            var neighbor_mesh = neighbor[@ MapCellContents.MESH];
            var neighbor_tile = neighbor[@ MapCellContents.TILE];
            if (instanceof_classic(neighbor_mesh, EntityMeshAutotile) && selected_border(neighbor_mesh, mask_mesh_auto) ||
                    instanceof_classic(neighbor_tile, EntityTile) && selected_border(neighbor_tile, mask_tile)
                ) {
                ds_list_add(list, thing);
            }
        }
        
        // northwest
        if (map.GetMeshAutotileData(thing.xx - 1, thing.yy - 1, thing.zz)) {
            var neighbor = map.Get(thing.xx - 1, thing.yy - 1, thing.zz);
            var neighbor_mesh = neighbor[@ MapCellContents.MESH];
            var neighbor_tile = neighbor[@ MapCellContents.TILE];
            if (instanceof_classic(neighbor_mesh, EntityMeshAutotile) && selected_border(neighbor_mesh, mask_mesh_auto) ||
                    instanceof_classic(neighbor_tile, EntityTile) && selected_border(neighbor_tile, mask_tile)
                ) {
                ds_list_add(list, thing);
            }
        }
        
        // northeast
        if (map.GetMeshAutotileData(thing.xx + 1, thing.yy - 1, thing.zz)) {
            var neighbor = map.Get(thing.xx + 1, thing.yy - 1, thing.zz);
            var neighbor_mesh = neighbor[@ MapCellContents.MESH];
            var neighbor_tile = neighbor[@ MapCellContents.TILE];
            if (instanceof_classic(neighbor_mesh, EntityMeshAutotile) && selected_border(neighbor_mesh, mask_mesh_auto) ||
                    instanceof_classic(neighbor_tile, EntityTile) && selected_border(neighbor_tile, mask_tile)
                ) {
                ds_list_add(list, thing);
            }
        }
        
        // southwest
        if (map.GetMeshAutotileData(thing.xx - 1, thing.yy + 1, thing.zz)) {
            var neighbor = map.Get(thing.xx - 1, thing.yy + 1, thing.zz);
            var neighbor_mesh = neighbor[@ MapCellContents.MESH];
            var neighbor_tile = neighbor[@ MapCellContents.TILE];
            if (instanceof_classic(neighbor_mesh, EntityMeshAutotile) && selected_border(neighbor_mesh, mask_mesh_auto) ||
                    instanceof_classic(neighbor_tile, EntityTile) && selected_border(neighbor_tile, mask_tile)
                ) {
                ds_list_add(list, thing);
            }
        }
        
        // southeast
        if (map.GetMeshAutotileData(thing.xx + 1, thing.yy + 1, thing.zz)) {
            var neighbor = map.Get(thing.xx + 1, thing.yy + 1, thing.zz);
            var neighbor_mesh = neighbor[@ MapCellContents.MESH];
            var neighbor_tile = neighbor[@ MapCellContents.TILE];
            if (instanceof_classic(neighbor_mesh, EntityMeshAutotile) && selected_border(neighbor_mesh, mask_mesh_auto) ||
                    instanceof_classic(neighbor_tile, EntityTile) && selected_border(neighbor_tile, mask_tile)
                ) {
                ds_list_add(list, thing);
            }
        }
    }
    
    return list;
}

function selected_border(entity, mask) {
    if (mask == undefined) mask = Settings.selection.mask;
    
    if (entity.etype_flags & mask) {
        for (var i = 0; i < array_length(Stuff.map.selection); i++) {
            if (Stuff.map.selection[i].selected_border_determination(entity)) {
                return true;
            }
        }
    }
    
    return false;
}

function selection_all() {
    // this is O(n). will not scale as well as i'd like. Use with caution.
    
    var list = ds_list_create();
    for (var i = 0; i < ds_list_size(Stuff.map.active_map.contents.all_entities); i++) {
        var thing = Stuff.map.active_map.contents.all_entities[| i];
        if (selected(thing)) {
            ds_list_add(list, thing);
        }
    }
    
    return list;
}

function selection_all_type(list) {
    // returns the object index; would use an enum but i like to keep things as
    // simple as possible on occasion, believe it or not
    // this is O(n). will not scale as well as i'd like. Use with caution.
    var latest_common_ancestor = noone;
    
    var all_tile = true;
    var all_tile_auto = true;
    var all_mesh = true;
    var all_mesh_autotile = true;
    var all_pawn = true;
    var all_effect = true;
    
    for (var i = 0; i < ds_list_size(list); i++) {
        var thing = list[| i];
        var object_type = thing.object_index;
        // if latest common ancestor is undefined, define it
        if (!latest_common_ancestor) {
            latest_common_ancestor = object_type;
        } else {
            // if Thing IS AN instance of the latest common ancestor, you're good
            if (!instanceof_classic(thing, latest_common_ancestor)) {
                // check each ancestor of Thing, and see if it is a common ancestor for
                // the current latest common ancestor
                while (object_type) {
                    if (latest_common_ancestor == object_type || object_is_ancestor(object_type, latest_common_ancestor)) {
                        latest_common_ancestor = object_type;
                        break;
                    }
                    object_type = object_get_parent(object_type);
                }
            }
        }
    }
    
    return latest_common_ancestor;
}

function selection_clear() {
    array_resize(Stuff.map.selection, 0);
    Stuff.map.last_selection = undefined;
    sa_process_selection();
}

function selection_empty() {
    return array_empty(Stuff.map.selection);
}

function selection_update_autotiles() {
    var terrain = selected_affected_terrain();
    var map = Stuff.map.active_map;
    
    static surrounded_mask = ATMask.NORTHWEST | ATMask.NORTH | ATMask.NORTHEAST | ATMask.WEST | ATMask.EAST | ATMask.SOUTHWEST | ATMask.SOUTH | ATMask.SOUTHEAST;
    
    for (var i = 0; i < ds_list_size(terrain); i++) {
        var thing = terrain[| i];
        var thing_is_mesh = instanceof_classic(thing, EntityMeshAutotile);
        if (thing_is_mesh && thing.terrain_type == MeshAutotileLayers.SLOPE) continue;
        var original_id = thing_is_mesh ? thing.terrain_id : -1;
        var original_type = thing.terrain_type;
        thing.terrain_id = get_autotile_id(thing);
        
        // evaluate top, base or middle
        if (thing.zz < map.zz - 1 && thing_is_mesh) {
            var above = (thing.zz < map.zz - 1) ? map.Get(thing.xx, thing.yy, thing.zz + 1) : array_create(MapCellContents._COUNT, noone);
            var below = (thing.zz > 0) ? map.Get(thing.xx, thing.yy, thing.zz - 1) : array_create(MapCellContents._COUNT, noone);
            // if an entity is marked as "removed," even if it's still there, it might as well not be there
            var above_exists = instanceof_classic(above[MapCellContents.MESH], EntityMeshAutotile) && (above[MapCellContents.MESH].modification != Modifications.REMOVE);
            var below_exists = instanceof_classic(below[MapCellContents.MESH], EntityMeshAutotile) && (below[MapCellContents.MESH].modification != Modifications.REMOVE);
            if (Settings.config.remove_covered_mesh_at && above_exists && thing.terrain_id & surrounded_mask) {
                if ((get_autotile_id(above[MapCellContents.MESH]) & surrounded_mask) == surrounded_mask) {
                    thing.modification = Modifications.REMOVE;
                    ds_list_add(Stuff.map.changes, thing);
                }
            } else if (above_exists && below_exists) {
                // is in middle?
                thing.terrain_type = MeshAutotileLayers.VERTICAL;
            } else if (below_exists) {
                // is on top?
                thing.terrain_type = MeshAutotileLayers.TOP;
            } else if (above_exists) {
                // is on bottom?
                thing.terrain_type = MeshAutotileLayers.BASE;
            } else {
                thing.terrain_type = MeshAutotileLayers.TOP;
            }
            
            // if the cell below contains another EntityMeshAutotile, it should be set to use
            // the vertical mesh instead of whatever it was on before, unless you've been deleted,
            // in which case it should go back to using the top one
            if (below_exists) {
                var below_thing = below[MapCellContents.MESH];
                below_thing.terrain_type = (thing.modification == Modifications.REMOVE) ? MeshAutotileLayers.TOP : MeshAutotileLayers.VERTICAL;
                editor_map_mark_changed(below_thing);
            }
        }
        
        // batched entities will need to be updated when changed
        if ((original_id != thing.terrain_id && original_id != -1) || (thing.terrain_type != original_type)) {
            editor_map_mark_changed(thing);
        }
    }
    
    ds_list_destroy(terrain);
}