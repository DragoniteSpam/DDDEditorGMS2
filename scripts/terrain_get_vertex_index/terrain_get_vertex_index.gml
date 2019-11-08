/// @param terrain
/// @param x
/// @param y
/// @param vertex

var terrain = argument[0];
var xx = argument[1];
var yy = argument[2];
var vertex = argument[3];

// the -1 is annoying and unfortunately comes up a lot. the vertex buffer
// would is actually one shorter in each dimension than the width and height,
// because of the way the squares are arranged.
return Stuff.graphics.format_size_basic * ((xx * (terrain.height - 1) + yy) * terrain.vertices_per_square + vertex);