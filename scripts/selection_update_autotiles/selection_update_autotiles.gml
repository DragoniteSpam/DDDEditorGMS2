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
        var above_exists = instanceof(above[MapCellContents.MESHPAWN], EntityMeshAutotile);
        var below = (thing.zz > 0) ? map_get_grid_cell(thing.xx, thing.yy, thing.zz - 1) : array_create(MapCellContents._COUNT, noone);
        var below_exists = instanceof(below[MapCellContents.MESHPAWN], EntityMeshAutotile);
        if (above_exists && below_exists) {
            // is in middle?
            thing.terrain_type = ATTerrainTypes.VERTICAL;
        } else if (below_exists) {
            // is on top?
            if (thing.slope) {
                thing.terrain_type = ATTerrainTypes.SLOPE;
            } else {
                thing.terrain_type = ATTerrainTypes.TOP;
            }
        } else if (above_exists) {
            // is on bottom?
            thing.terrain_type = ATTerrainTypes.BASE;
        } else {
            // is standalone?
            if (thing.slope) {
                thing.terrain_type = ATTerrainTypes.SLOPE;
            } else {
                thing.terrain_type = ATTerrainTypes.TOP;
            }
        }
        
        // if the cell below contains another EntityMeshAutotile, it should be set to use
        // the vertical mesh instead of whatever it was on before, unless you've been deleted,
        // in which case it should go back to using the top one
        if (below_exists) {
            var below_thing = below[MapCellContents.MESHPAWN];
            debug(thing.modification == Modifications.REMOVE);
            below_thing.terrain_type = (thing.modification == Modifications.REMOVE) ? ATTerrainTypes.TOP : ATTerrainTypes.VERTICAL;
            editor_map_mark_changed(below_thing);
        }
    }
    
    // batched entities will need to be updated when changed
    if ((original_id != thing.terrain_id && original_id != -1) || (thing.terrain_type != original_type)) {
        editor_map_mark_changed(thing);
    }
}

ds_list_destroy(terrain);