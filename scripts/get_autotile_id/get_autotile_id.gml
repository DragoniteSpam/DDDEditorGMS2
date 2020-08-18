/// @param EntityTerrain
function get_autotile_id(argument0) {

	var terrain = argument0;
	var mask = 0;
	var map = Stuff.map.active_map;
	var map_contents = map.contents;

	// northwest
	var what = map_get_grid_cell_mesh_autotile_data(terrain.xx - 1, terrain.yy - 1, terrain.zz);
	var north = map_get_grid_cell_mesh_autotile_data(terrain.xx, terrain.yy - 1, terrain.zz);
	var west = map_get_grid_cell_mesh_autotile_data(terrain.xx - 1, terrain.yy, terrain.zz);
	if (what && north && west) {
	    mask |= ATMask.NORTHWEST;
	}

	// north
	var what = map_get_grid_cell_mesh_autotile_data(terrain.xx, terrain.yy - 1, terrain.zz);
	if (what) {
	    mask |= ATMask.NORTH;
	}

	// northeast
	var what = map_get_grid_cell_mesh_autotile_data(terrain.xx + 1, terrain.yy - 1, terrain.zz);
	var north = map_get_grid_cell_mesh_autotile_data(terrain.xx, terrain.yy - 1, terrain.zz);
	var east = map_get_grid_cell_mesh_autotile_data(terrain.xx + 1, terrain.yy, terrain.zz);
	if (what && north && east) {
	    mask |= ATMask.NORTHEAST;
	}

	// west
	var what = map_get_grid_cell_mesh_autotile_data(terrain.xx - 1, terrain.yy, terrain.zz);
	if (what) {
	    mask |= ATMask.WEST;
	}

	// east
	var what = map_get_grid_cell_mesh_autotile_data(terrain.xx + 1, terrain.yy, terrain.zz);
	if (what) {
	    mask |= ATMask.EAST;
	}

	// southwest
	var what = map_get_grid_cell_mesh_autotile_data(terrain.xx - 1, terrain.yy + 1, terrain.zz);
	var west = map_get_grid_cell_mesh_autotile_data(terrain.xx - 1, terrain.yy, terrain.zz);
	var south = map_get_grid_cell_mesh_autotile_data(terrain.xx, terrain.yy + 1, terrain.zz);
	if (what && west && south) {
	    mask |= ATMask.SOUTHWEST;
	}

	// south
	var what = map_get_grid_cell_mesh_autotile_data(terrain.xx, terrain.yy + 1, terrain.zz);
	if (what) {
	    mask |= ATMask.SOUTH;
	}

	// southeast
	var what = map_get_grid_cell_mesh_autotile_data(terrain.xx + 1, terrain.yy + 1, terrain.zz);
	var south = map_get_grid_cell_mesh_autotile_data(terrain.xx, terrain.yy + 1, terrain.zz);
	var east = map_get_grid_cell_mesh_autotile_data(terrain.xx + 1, terrain.yy, terrain.zz);
	if (what && south && east) {
	    mask |= ATMask.SOUTHEAST;
	}

	return mask;


}
