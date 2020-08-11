/// @param xx
/// @param yy
/// @param zz
/// @param tag

var xx = argument0;
var yy = argument1;
var zz = argument2;
var tag = argument3;
var map_contents = Stuff.map.active_map.contents;

/// @gml chained accessors
var column = map_contents.map_grid_frozen_tags[# xx, yy];
column[@ zz] = tag;