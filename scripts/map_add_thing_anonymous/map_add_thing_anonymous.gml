/// @param collision-mask
/// @param x
/// @param y
/// @param z
/// @param [map]
/// @param [slot]
// Does not check to see if the specified coordinates are in bounds.
// You are responsible for that.

var mask = 1000 + argument[0];
var xx = argument[1];
var yy = argument[2];
var zz = argument[3];
var map = (argument_count > 4) ? argument[4] : Stuff.active_map;
var slot = (argument_count > 5) ? argument[5] : MapCellContents.TILE;
var map_contents = map.contents;

var cell = map_get_grid_cell(xx, yy, zz, map);

// only add thing if the space is not already occupied
if (!cell[@ slot]) {
    cell[@ slot] = mask;
}