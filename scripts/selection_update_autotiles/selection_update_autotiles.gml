var terrain = selected_affected_terrain();
var map = Stuff.map.active_map;

for (var i = 0; i < ds_list_size(terrain); i++) {
    var thing = terrain[| i];
    var thing_is_mesh = instanceof(thing, EntityMeshAutotile);
    var original_id = thing_is_mesh ? thing.terrain_id : -1;
    var original_type = thing.terrain_type;
    thing.terrain_id = get_autotile_id(thing);
    
    // evaluate top, base or middle
    if (thing.zz < map.zz - 1 && thing_is_mesh) {
        var above = (thing.zz < map.zz - 1) ? map_get_grid_cell(thing.xx, thing.yy, thing.zz + 1) : array_create(MapCellContents._COUNT, noone);
        var below = (thing.zz > 0) ? map_get_grid_cell(thing.xx, thing.yy, thing.zz - 1) : array_create(MapCellContents._COUNT, noone);
        // is in middle?
        if (instanceof(above[MapCellContents.MESHPAWN], EntityMeshAutotile) && instanceof(below[MapCellContents.MESHPAWN], EntityMeshAutotile)) {
            thing.terrain_type = ATTerrainTypes.VERTICAL;
        // is on top?
        } else if (instanceof(below[MapCellContents.MESHPAWN], EntityMeshAutotile)) {
            // is marked as slope?
            if (thing.slope) {
                thing.terrain_type = ATTerrainTypes.SLOPE;
            } else {
                thing.terrain_type = ATTerrainTypes.TOP;
            }
        // is on bottom?
        } else {
            thing.terrain_type = ATTerrainTypes.BASE;
        }
    }
    
    // batched entities will need to be updated when changed
    if ((original_id != thing.terrain_id && original_id != -1) || (thing.terrain_type != original_type)) {
        editor_map_mark_changed(thing);
    }
    
    // if the cell below contains another EntityMeshAutotile, it should be set to use
    // the vertical mesh instead of the base one
    if (thing.zz > 0) {
        var below_cell = map_get_grid_cell(thing.xx, thing.yy, thing.zz - 1);
        var below_thing = below_cell[MapCellContents.MESHPAWN];
        if (instanceof(below_thing, EntityMeshAutotile)) {
            var original_type = below_thing.terrain_type;
            below_thing.terrain_type = ATTerrainTypes.VERTICAL;
            if (original_type != thing.terrain_type) {
                editor_map_mark_changed(below_thing);
            }
    
        }
    }
}

ds_list_destroy(terrain);