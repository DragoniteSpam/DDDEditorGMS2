/// @param json
/// @param tileset-columns
/// @param z
/// @param alpha
/// @param x
/// @param y

var json = argument[0];
var columns = argument[1];
var z = argument[2];
var alpha = (argument_count > 3) ? argument[3] : 1;
var xx = (argument_count > 4) ? argument[4] : 0;
var yy = (argument_count > 5) ? argument[5] : 0;
var zz = z div TILED_MAP_LAYERS_PER_BASE_LAYER;

return z;