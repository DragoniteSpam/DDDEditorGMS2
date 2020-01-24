/// @param EntityTerrain

var terrain = argument0;
var mask = 0;
var map = Stuff.map.active_map;
var map_contents = map.contents;

// northwest
if (terrain.xx > 0 && terrain.yy > 0) {
    // @gml update
    var what = map_get_grid_cell(terrain.xx - 1, terrain.yy - 1, terrain.zz);
    var north = map_get_grid_cell(terrain.xx, terrain.yy - 1, terrain.zz);
    var west = map_get_grid_cell(terrain.xx - 1, terrain.yy, terrain.zz);
    if (instanceof(what[MapCellContents.MESHPAWN], EntityMeshTerrain) &&
            instanceof(west[MapCellContents.MESHPAWN], EntityMeshTerrain) &&
            instanceof(north[MapCellContents.MESHPAWN], EntityMeshTerrain)
        ) {
        mask = mask | ATMask.NORTHWEST;
    }
}

// north
if (terrain.yy > 0) {
    // @gml update
    var what = map_get_grid_cell(terrain.xx, terrain.yy - 1, terrain.zz);
    if (instanceof(what[MapCellContents.MESHPAWN], EntityMeshTerrain)) {
        mask = mask | ATMask.NORTH;
    }
}

// northeast
if (terrain.xx < map.xx - 1 && terrain.yy > 0) {
    // @gml update
    var what = map_get_grid_cell(terrain.xx + 1, terrain.yy - 1, terrain.zz);
    var north = map_get_grid_cell(terrain.xx, terrain.yy - 1, terrain.zz);
    var east = map_get_grid_cell(terrain.xx + 1, terrain.yy, terrain.zz);
    if (instanceof(what[MapCellContents.MESHPAWN], EntityMeshTerrain) &&
            instanceof(north[MapCellContents.MESHPAWN], EntityMeshTerrain) &&
            instanceof(east[MapCellContents.MESHPAWN], EntityMeshTerrain)
        ) {
        mask = mask | ATMask.NORTHEAST;
    }
}

// west
if (terrain.xx > 0) {
    // @gml update
    var what = map_get_grid_cell(terrain.xx - 1, terrain.yy, terrain.zz);
    if (instanceof(what[MapCellContents.MESHPAWN], EntityMeshTerrain)) {
        mask = mask | ATMask.WEST;
    }
}

// east
if (terrain.xx < map.xx - 1) {
    // @gml update
    var what = map_get_grid_cell(terrain.xx + 1, terrain.yy, terrain.zz);
    if (instanceof(what[MapCellContents.MESHPAWN], EntityMeshTerrain)) {
        mask = mask | ATMask.EAST;
    }
}

// southwest
if (terrain.xx > 0 && terrain.yy < map.yy - 1) {
    // @gml update
    var what = map_get_grid_cell(terrain.xx - 1, terrain.yy + 1, terrain.zz);
    var west = map_get_grid_cell(terrain.xx - 1, terrain.yy, terrain.zz);
    var south = map_get_grid_cell(terrain.xx, terrain.yy + 1, terrain.zz);
    if (instanceof(what[MapCellContents.MESHPAWN], EntityMeshTerrain) &&
            instanceof(west[MapCellContents.MESHPAWN], EntityMeshTerrain) &&
            instanceof(south[MapCellContents.MESHPAWN], EntityMeshTerrain)
        ) {
        mask = mask | ATMask.SOUTHWEST;
    }
}

// south
if (terrain.yy < map.yy - 1) {
    // @gml update
    var what = map_get_grid_cell(terrain.xx, terrain.yy + 1, terrain.zz);
    if (instanceof(what[MapCellContents.MESHPAWN], EntityMeshTerrain)) {
        mask = mask | ATMask.SOUTH;
    }
}

// southeast
if (terrain.xx < map.xx - 1 && terrain.yy < map.yy - 1) {
    // @gml update
    var what = map_get_grid_cell(terrain.xx + 1, terrain.yy + 1, terrain.zz);
    var south = map_get_grid_cell(terrain.xx, terrain.yy + 1, terrain.zz);
    var east = map_get_grid_cell(terrain.xx + 1, terrain.yy, terrain.zz);
    if (instanceof(what[MapCellContents.MESHPAWN], EntityMeshTerrain) &&
            instanceof(south[MapCellContents.MESHPAWN], EntityMeshTerrain) &&
            instanceof(east[MapCellContents.MESHPAWN], EntityMeshTerrain)
        ) {
        mask = mask | ATMask.SOUTHEAST;
    }
}

return mask;