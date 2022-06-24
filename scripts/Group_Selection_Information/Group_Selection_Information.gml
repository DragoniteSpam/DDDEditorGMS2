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

function selection_delete(entity) {
    if (entity.modification == Modifications.NONE) {
        entity.modification = Modifications.REMOVE;
        ds_list_add(Stuff.map.changes, entity);
    }
}

function selected(entity, mask = Settings.selection.mask) {
    // all Entities will mask against ETypeFlags.ENTITY (0x1);
    // if you want a helpful selection determination, remove that
    // flag from the mask.
    if (entity.etype_flags & mask) {
        for (var i = 0; i < array_length(Stuff.map.selection); i++) {
            if (Stuff.map.selection[i].selected_determination(entity)) {
                return true;
            }
        }
    }
    
    return false;
}

function sa_process_selection() {
    var list = selection_all();
    var map = Stuff.map.active_map;
    
    ds_list_destroy(Stuff.map.selected_entities);
    Stuff.map.selected_entities = list;
    
    Stuff.map.ui.Refresh(list);
}

function selected_affected_terrain() {
    // this is O(n). will not scale as well as i'd like. Use with caution.
    var map = Stuff.map.active_map;
    var list = ds_list_create();
    var mask_mesh_auto = ETypeFlags.ENTITY_MESH_AUTO;
    var mask_tile = ETypeFlags.ENTITY_TILE;
    
    for (var i = 0; i < ds_list_size(Stuff.map.active_map.contents.all_entities); i++) {
        var thing = Stuff.map.active_map.contents.all_entities[| i];
        
        if (thing.etype != ETypes.ENTITY_MESH_AUTO) continue;
        
        if (selected_border(thing)) {
            ds_list_add(list, thing);
        }
        
        // above
        if (map.GetMeshAutotileData(thing.xx, thing.yy, thing.zz + 1)) {
            var neighbor = map.Get(thing.xx, thing.yy, thing.zz + 1);
            var neighbor_mesh = neighbor[@ MapCellContents.MESH];
            var neighbor_tile = neighbor[@ MapCellContents.TILE];
            if ((neighbor_mesh && neighbor_mesh.etype == ETypes.ENTITY_MESH_AUTO && selected_border(neighbor_mesh, mask_mesh_auto)) ||
                    (neighbor_tile && neighbor_tile.etype == ETypes.ENTITY_MESH_AUTO && selected_border(neighbor_tile, mask_tile))) {
                ds_list_add(list, thing);
            }
        }
        
        // below
        if (map.GetMeshAutotileData(thing.xx, thing.yy, thing.zz - 1)) {
            var neighbor = map.Get(thing.xx, thing.yy, thing.zz - 1);
            var neighbor_mesh = neighbor[@ MapCellContents.MESH];
            var neighbor_tile = neighbor[@ MapCellContents.TILE];
            if ((neighbor_mesh && neighbor_mesh.etype == ETypes.ENTITY_MESH_AUTO && selected_border(neighbor_mesh, mask_mesh_auto)) ||
                    (neighbor_tile && neighbor_tile.etype == ETypes.ENTITY_MESH_AUTO && selected_border(neighbor_tile, mask_tile))) {
                ds_list_add(list, thing);
            }
        }
        
        // north
        if (map.GetMeshAutotileData(thing.xx, thing.yy - 1, thing.zz)) {
            var neighbor = map.Get(thing.xx, thing.yy - 1, thing.zz);
            var neighbor_mesh = neighbor[@ MapCellContents.MESH];
            var neighbor_tile = neighbor[@ MapCellContents.TILE];
            if ((neighbor_mesh && neighbor_mesh.etype == ETypes.ENTITY_MESH_AUTO && selected_border(neighbor_mesh, mask_mesh_auto)) ||
                    (neighbor_tile && neighbor_tile.etype == ETypes.ENTITY_MESH_AUTO && selected_border(neighbor_tile, mask_tile))) {
                ds_list_add(list, thing);
            }
        }
        
        // south
        if (map.GetMeshAutotileData(thing.xx, thing.yy + 1, thing.zz)) {
            var neighbor = map.Get(thing.xx, thing.yy + 1, thing.zz);
            var neighbor_mesh = neighbor[@ MapCellContents.MESH];
            var neighbor_tile = neighbor[@ MapCellContents.TILE];
            if ((neighbor_mesh && neighbor_mesh.etype == ETypes.ENTITY_MESH_AUTO && selected_border(neighbor_mesh, mask_mesh_auto)) ||
                    (neighbor_tile && neighbor_tile.etype == ETypes.ENTITY_MESH_AUTO && selected_border(neighbor_tile, mask_tile))) {
                ds_list_add(list, thing);
            }
        }
        
        // east
        if (map.GetMeshAutotileData(thing.xx + 1, thing.yy, thing.zz)) {
            var neighbor = map.Get(thing.xx + 1, thing.yy, thing.zz);
            var neighbor_mesh = neighbor[@ MapCellContents.MESH];
            var neighbor_tile = neighbor[@ MapCellContents.TILE];
            if ((neighbor_mesh && neighbor_mesh.etype == ETypes.ENTITY_MESH_AUTO && selected_border(neighbor_mesh, mask_mesh_auto)) ||
                    (neighbor_tile && neighbor_tile.etype == ETypes.ENTITY_MESH_AUTO && selected_border(neighbor_tile, mask_tile))) {
                ds_list_add(list, thing);
            }
        }
        
        // west
        if (map.GetMeshAutotileData(thing.xx - 1, thing.yy, thing.zz)) {
            var neighbor = map.Get(thing.xx - 1, thing.yy, thing.zz);
            var neighbor_mesh = neighbor[@ MapCellContents.MESH];
            var neighbor_tile = neighbor[@ MapCellContents.TILE];
            if ((neighbor_mesh && neighbor_mesh.etype == ETypes.ENTITY_MESH_AUTO && selected_border(neighbor_mesh, mask_mesh_auto)) ||
                    (neighbor_tile && neighbor_tile.etype == ETypes.ENTITY_MESH_AUTO && selected_border(neighbor_tile, mask_tile))) {
                ds_list_add(list, thing);
            }
        }
        
        // northwest
        if (map.GetMeshAutotileData(thing.xx - 1, thing.yy - 1, thing.zz)) {
            var neighbor = map.Get(thing.xx - 1, thing.yy - 1, thing.zz);
            var neighbor_mesh = neighbor[@ MapCellContents.MESH];
            var neighbor_tile = neighbor[@ MapCellContents.TILE];
            if ((neighbor_mesh && neighbor_mesh.etype == ETypes.ENTITY_MESH_AUTO && selected_border(neighbor_mesh, mask_mesh_auto)) ||
                    (neighbor_tile && neighbor_tile.etype == ETypes.ENTITY_MESH_AUTO && selected_border(neighbor_tile, mask_tile))) {
                ds_list_add(list, thing);
            }
        }
        
        // northeast
        if (map.GetMeshAutotileData(thing.xx + 1, thing.yy - 1, thing.zz)) {
            var neighbor = map.Get(thing.xx + 1, thing.yy - 1, thing.zz);
            var neighbor_mesh = neighbor[@ MapCellContents.MESH];
            var neighbor_tile = neighbor[@ MapCellContents.TILE];
            if ((neighbor_mesh && neighbor_mesh.etype == ETypes.ENTITY_MESH_AUTO && selected_border(neighbor_mesh, mask_mesh_auto)) ||
                    (neighbor_tile && neighbor_tile.etype == ETypes.ENTITY_MESH_AUTO && selected_border(neighbor_tile, mask_tile))) {
                ds_list_add(list, thing);
            }
        }
        
        // southwest
        if (map.GetMeshAutotileData(thing.xx - 1, thing.yy + 1, thing.zz)) {
            var neighbor = map.Get(thing.xx - 1, thing.yy + 1, thing.zz);
            var neighbor_mesh = neighbor[@ MapCellContents.MESH];
            var neighbor_tile = neighbor[@ MapCellContents.TILE];
            if ((neighbor_mesh && neighbor_mesh.etype == ETypes.ENTITY_MESH_AUTO && selected_border(neighbor_mesh, mask_mesh_auto)) ||
                    (neighbor_tile && neighbor_tile.etype == ETypes.ENTITY_MESH_AUTO && selected_border(neighbor_tile, mask_tile))) {
                ds_list_add(list, thing);
            }
        }
        
        // southeast
        if (map.GetMeshAutotileData(thing.xx + 1, thing.yy + 1, thing.zz)) {
            var neighbor = map.Get(thing.xx + 1, thing.yy + 1, thing.zz);
            var neighbor_mesh = neighbor[@ MapCellContents.MESH];
            var neighbor_tile = neighbor[@ MapCellContents.TILE];
            if ((neighbor_mesh && neighbor_mesh.etype == ETypes.ENTITY_MESH_AUTO && selected_border(neighbor_mesh, mask_mesh_auto)) ||
                    (neighbor_tile && neighbor_tile.etype == ETypes.ENTITY_MESH_AUTO && selected_border(neighbor_tile, mask_tile))) {
                ds_list_add(list, thing);
            }
        }
    }
    
    return list;
}

function selected_border(entity, mask = Settings.selection.mask) {
    // all Entities will mask against ETypeFlags.ENTITY (0x1);
    // if you want a helpful selection determination, ignore those cases
    if (entity.etype_flags & mask > ETypeFlags.ENTITY) {
        for (var i = 0; i < array_length(Stuff.map.selection); i++) {
            if (Stuff.map.selection[i].selected_border_determination(entity)) {
                return true;
            }
        }
    }
    
    return false;
}

function selection_all() {
    // this is O(n*m). will not scale as well as i'd like. Use with caution.
    // in the future it may be useful to turn this into some sort of spatial
    // hierarchy of sorts.
    
    var list = ds_list_create();
    for (var i = 0, n = ds_list_size(Stuff.map.active_map.contents.all_entities); i < n; i++) {
        var thing = Stuff.map.active_map.contents.all_entities[| i];
        if (selected(thing)) {
            ds_list_add(list, thing);
        }
    }
    
    return list;
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
    
    for (var i = 0, n = ds_list_size(terrain); i < n; i++) {
        var thing = terrain[| i];
        var thing_is_mesh = (thing.etype == ETypes.ENTITY_MESH_AUTO);
        if (thing_is_mesh && thing.terrain_type == MeshAutotileLayers.SLOPE) continue;
        var original_id = thing_is_mesh ? thing.terrain_id : -1;
        var original_type = thing.terrain_type;
        thing.terrain_id = get_autotile_id(thing);
        
        // evaluate top, base or middle
        if (thing.zz < map.zz - 1 && thing_is_mesh) {
            var above = (thing.zz < map.zz - 1) ? map.Get(thing.xx, thing.yy, thing.zz + 1) : array_create(MapCellContents._COUNT, undefined);
            var below = (thing.zz > 0) ? map.Get(thing.xx, thing.yy, thing.zz - 1) : array_create(MapCellContents._COUNT, undefined);
            // if an entity is marked as "removed," even if it's still there, it might as well not be there
            var above_exists = (above[MapCellContents.MESH] && above[MapCellContents.MESH].etype == ETypes.ENTITY_MESH_AUTO && (above[MapCellContents.MESH].modification != Modifications.REMOVE));
            var below_exists = (below[MapCellContents.MESH] && below[MapCellContents.MESH].etype == ETypes.ENTITY_MESH_AUTO && (below[MapCellContents.MESH].modification != Modifications.REMOVE));
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