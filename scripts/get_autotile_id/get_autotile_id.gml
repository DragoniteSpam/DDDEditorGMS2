/// @param EntityTerrain

var mask = 0;

// northwest
if (argument0.xx > 0 && argument0.yy > 0) {
    // @todo gml update
    var what = map_get_grid_cell(argument0.xx - 1, argument0.yy - 1, argument0.zz);
    if (instanceof(what[MapCellContents.MESHMOB], EntityTile)) {
        mask = mask | ATMask.NORTHWEST;
    }
}

// north
if (argument0.yy > 0) {
    // @todo gml update
    var what = map_get_grid_cell(argument0.xx, argument0.yy - 1, argument0.zz);
    if (instanceof(what[MapCellContents.MESHMOB], EntityTile)) {
        mask = mask | ATMask.NORTH;
    }
}

// northeast
if (argument0.xx < ActiveMap.xx - 1 && argument0.yy > 0) {
    // @todo gml update
    var what = map_get_grid_cell(argument0.xx + 1, argument0.yy - 1, argument0.zz);
    if (instanceof(what[MapCellContents.MESHMOB], EntityTile)) {
        mask = mask | ATMask.NORTHEAST;
    }
}

// west
if (argument0.xx > 0) {
    // @todo gml update
    var what = map_get_grid_cell(argument0.xx - 1, argument0.yy, argument0.zz);
    if (instanceof(what[MapCellContents.MESHMOB], EntityTile)) {
        mask = mask | ATMask.WEST;
    }
}

// east
if (argument0.xx < ActiveMap.xx - 1) {
    // @todo gml update
    var what = map_get_grid_cell(argument0.xx + 1, argument0.yy, argument0.zz);
    if (instanceof(what[MapCellContents.MESHMOB], EntityTile)) {
        mask = mask | ATMask.EAST;
    }
}

// southwest
if (argument0.xx > 0 && argument0.yy < ActiveMap.yy - 1) {
    // @todo gml update
    var what = map_get_grid_cell(argument0.xx - 1, argument0.yy + 1, argument0.zz);
    if (instanceof(what[MapCellContents.MESHMOB], EntityTile)) {
        mask = mask | ATMask.SOUTHWEST;
    }
}

// south
if (argument0.yy < ActiveMap.yy - 1) {
    // @todo gml update
    var what = map_get_grid_cell(argument0.xx, argument0.yy + 1, argument0.zz);
    if (instanceof(what[MapCellContents.MESHMOB], EntityTile)) {
        mask = mask | ATMask.SOUTH;
    }
}

// southeast
if (argument0.xx < ActiveMap.xx - 1 && argument0.yy < ActiveMap.yy - 1) {
    // @todo gml update
    var what = map_get_grid_cell(argument0.xx + 1, argument0.yy + 1, argument0.zz);
    if (instanceof(what[MapCellContents.MESHMOB], EntityTile)) {
        mask = mask | ATMask.SOUTHEAST;
    }
}

return mask;