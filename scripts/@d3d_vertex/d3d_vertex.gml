/// @description d3d - Sets the primitive vertex
/// @param x the x position
/// @param y the y position
/// @param z the z position

vertex_position_3d( global.__d3dPrimBuffer, argument0, argument1, argument2 );
vertex_normal( global.__d3dPrimBuffer, 0, 0, 0 );
vertex_colour( global.__d3dPrimBuffer, draw_get_colour(), draw_get_alpha());
vertex_texcoord( global.__d3dPrimBuffer, 0, 0 );



