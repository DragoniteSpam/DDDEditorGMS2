/// @param terrain
/// @param x
/// @param y
/// @param vertex

var terrain = argument[0];
var xx = argument[1];
var yy = argument[2];
var vertex = argument[3];

return terrain.format_size * (((xx - 1) * terrain.height + (yy - 1)) * terrain.vertices_per_square + vertex);