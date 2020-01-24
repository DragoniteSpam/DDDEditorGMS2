/// @param EntityTerrain

var terrain = argument0;
var mask = 0;
var map = Stuff.map.active_map;
var map_contents = map.contents;

// northwest
if (terrain.xx > 0 && terrain.yy > 0) {
    var what = map_get_grid_cell_mesh_autotile_data(terrain.xx - 1, terrain.yy - 1, terrain.zz);
    var north = map_get_grid_cell_mesh_autotile_data(terrain.xx, terrain.yy - 1, terrain.zz);
    var west = map_get_grid_cell_mesh_autotile_data(terrain.xx - 1, terrain.yy, terrain.zz);
    if (what && north && west) {
        mask = mask | ATMask.NORTHWEST;
    }
}

// north
if (terrain.yy > 0) {
    var what = map_get_grid_cell_mesh_autotile_data(terrain.xx, terrain.yy - 1, terrain.zz);
    if (what) {
        mask = mask | ATMask.NORTH;
    }
}

// northeast
if (terrain.xx < map.xx - 1 && terrain.yy > 0) {
    var what = map_get_grid_cell_mesh_autotile_data(terrain.xx + 1, terrain.yy - 1, terrain.zz);
    var north = map_get_grid_cell_mesh_autotile_data(terrain.xx, terrain.yy - 1, terrain.zz);
    var east = map_get_grid_cell_mesh_autotile_data(terrain.xx + 1, terrain.yy, terrain.zz);
    if (what && north && east) {
        mask = mask | ATMask.NORTHEAST;
    }
}

// west
if (terrain.xx > 0) {
    var what = map_get_grid_cell_mesh_autotile_data(terrain.xx - 1, terrain.yy, terrain.zz);
    if (what) {
        mask = mask | ATMask.WEST;
    }
}

// east
if (terrain.xx < map.xx - 1) {
    var what = map_get_grid_cell_mesh_autotile_data(terrain.xx + 1, terrain.yy, terrain.zz);
    if (what) {
        mask = mask | ATMask.EAST;
    }
}

// southwest
if (terrain.xx > 0 && terrain.yy < map.yy - 1) {
    var what = map_get_grid_cell_mesh_autotile_data(terrain.xx - 1, terrain.yy + 1, terrain.zz);
    var west = map_get_grid_cell_mesh_autotile_data(terrain.xx - 1, terrain.yy, terrain.zz);
    var south = map_get_grid_cell_mesh_autotile_data(terrain.xx, terrain.yy + 1, terrain.zz);
    if (what && west && south) {
        mask = mask | ATMask.SOUTHWEST;
    }
}

// south
if (terrain.yy < map.yy - 1) {
    var what = map_get_grid_cell_mesh_autotile_data(terrain.xx, terrain.yy + 1, terrain.zz);
    if (what) {
        mask = mask | ATMask.SOUTH;
    }
}

// southeast
if (terrain.xx < map.xx - 1 && terrain.yy < map.yy - 1) {
    var what = map_get_grid_cell_mesh_autotile_data(terrain.xx + 1, terrain.yy + 1, terrain.zz);
    var south = map_get_grid_cell_mesh_autotile_data(terrain.xx, terrain.yy + 1, terrain.zz);
    var east = map_get_grid_cell_mesh_autotile_data(terrain.xx + 1, terrain.yy, terrain.zz);
    if (what && south && east) {
        mask = mask | ATMask.SOUTHEAST;
    }
}

return mask;