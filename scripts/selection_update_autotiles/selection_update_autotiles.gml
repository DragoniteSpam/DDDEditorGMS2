var terrain = selected_affected_terrain();
var map = Stuff.map.active_map;

for (var i = 0; i < ds_list_size(terrain); i++) {
    var thing = terrain[| i];
    thing.terrain_id = get_autotile_id(thing);
    thing.terrain_type = ATTerrainTypes.BASE;
    
    if (thing.zz < map.zz - 1) {
        var above = map_get_grid_cell(thing.xx, thing.yy, thing.zz + 1);
        if (instanceof(above[MapCellContents.MESHPAWN], EntityMeshAutotile)) {
            thing.terrain_type = ATTerrainTypes.VERTICAL;
        }
    }
    
    // if the cell below contains another EntityMeshAutotile, it should be set to use
    // the vertical mesh instead of the base one
    if (thing.zz > 0) {
        var below_cell = map_get_grid_cell(thing.xx, thing.yy, thing.zz - 1);
        var below_thing = below_cell[MapCellContents.MESHPAWN];
        if (instanceof(below_thing, EntityMeshAutotile)) {
            below_thing.terrain_id = thing.terrain_id;
            below_thing.terrain_type = ATTerrainTypes.VERTICAL;
        }
    }
}

ds_list_destroy(terrain);