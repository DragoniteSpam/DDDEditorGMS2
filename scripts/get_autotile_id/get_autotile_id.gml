/// @param EntityTerrain

var terrain = argument0;
var mask = 0;
var map = Stuff.active_map.contents;

// northwest
if (terrain.xx > 0 && terrain.yy > 0) {
    // @todo gml update
    var what = map_get_grid_cell(terrain.xx - 1, terrain.yy - 1, terrain.zz);
    if (instanceof(what[MapCellContents.MESHPAWN], EntityMeshTerrain)) {
        mask = mask | ATMask.NORTHWEST;
    }
}

// north
if (terrain.yy > 0) {
    // @todo gml update
    var what = map_get_grid_cell(terrain.xx, terrain.yy - 1, terrain.zz);
    if (instanceof(what[MapCellContents.MESHPAWN], EntityMeshTerrain)) {
        mask = mask | ATMask.NORTH;
    }
}

// northeast
if (terrain.xx < map.xx - 1 && terrain.yy > 0) {
    // @todo gml update
    var what = map_get_grid_cell(terrain.xx + 1, terrain.yy - 1, terrain.zz);
    if (instanceof(what[MapCellContents.MESHPAWN], EntityMeshTerrain)) {
        mask = mask | ATMask.NORTHEAST;
    }
}

// west
if (terrain.xx > 0) {
    // @todo gml update
    var what = map_get_grid_cell(terrain.xx - 1, terrain.yy, terrain.zz);
    if (instanceof(what[MapCellContents.MESHPAWN], EntityMeshTerrain)) {
        mask = mask | ATMask.WEST;
    }
}

// east
if (terrain.xx < map.xx - 1) {
    // @todo gml update
    var what = map_get_grid_cell(terrain.xx + 1, terrain.yy, terrain.zz);
    if (instanceof(what[MapCellContents.MESHPAWN], EntityMeshTerrain)) {
        mask = mask | ATMask.EAST;
    }
}

// southwest
if (terrain.xx > 0 && terrain.yy < map.yy - 1) {
    // @todo gml update
    var what = map_get_grid_cell(terrain.xx - 1, terrain.yy + 1, terrain.zz);
    if (instanceof(what[MapCellContents.MESHPAWN], EntityMeshTerrain)) {
        mask = mask | ATMask.SOUTHWEST;
    }
}

// south
if (terrain.yy < map.yy - 1) {
    // @todo gml update
    var what = map_get_grid_cell(terrain.xx, terrain.yy + 1, terrain.zz);
    if (instanceof(what[MapCellContents.MESHPAWN], EntityMeshTerrain)) {
        mask = mask | ATMask.SOUTH;
    }
}

// southeast
if (terrain.xx < map.xx - 1 && terrain.yy < map.yy - 1) {
    // @todo gml update
    var what = map_get_grid_cell(terrain.xx + 1, terrain.yy + 1, terrain.zz);
    if (instanceof(what[MapCellContents.MESHPAWN], EntityMeshTerrain)) {
        mask = mask | ATMask.SOUTHEAST;
    }
}

return mask;