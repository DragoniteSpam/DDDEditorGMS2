/// @param xx
/// @param yy
/// @param zz
/// @param [map]
// returns true / false instead of a found instance

var xx = argument[0];
var yy = argument[1];
var zz = argument[2];
var map = (argument_count > 3) ? argument[3] : Stuff.map.active_map;

if (!is_clamped(xx, 0, map.xx - 1) || !is_clamped(yy, 0, map.yy - 1) || !is_clamped(zz, 0, map.zz - 1)) {
    return false;
}

var result = false;

var cell = map_get_grid_cell(xx, yy, zz, map);
if (is_array(cell)) {
    var what = cell[@ MapCellContents.MESHPAWN];
    result = result || (instanceof(what, EntityMeshAutotile) && what.modification != Modifications.REMOVE);
}

// check the cell above you for a tile, because tiles kinda appear to
// exist on the layer below where they actually are
var cell = map_get_grid_cell(xx, yy, zz + 1, map);
if (is_array(cell)) {
    var what = cell[@ MapCellContents.TILE];
    result = result || (what && what.modification != Modifications.REMOVE);
}

return result;