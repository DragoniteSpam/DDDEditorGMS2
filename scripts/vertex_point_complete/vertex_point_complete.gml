/// @description void vertex_point_complete(vbuff, x, y, z, nx, ny, nz, xtex, ytex, color, alpha, [id]);
/// @param vbuff
/// @param x
/// @param y
/// @param z
/// @param nx
/// @param ny
/// @param nz
/// @param xtex
/// @param ytex
/// @param color
/// @param alpha
/// @param [id]
// Assume vbuff is a vertex buffer created using the correct format.

var atid=0;
switch (argument_count) {
    case 12:
        atid=argument[11];
        break;
}

vertex_position_3d(argument[0], argument[1], argument[2], argument[3]);
vertex_normal(argument[0], argument[4], argument[5], argument[6]);
vertex_texcoord(argument[0], argument[7], argument[8]);
vertex_colour(argument[0], argument[9], argument[10]);
// todo this
vertex_colour(argument[0], make_colour_rgb(0, 0, 0), 1);
