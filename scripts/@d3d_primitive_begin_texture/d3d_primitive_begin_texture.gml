/// @description  d3d - begin making a primitive stream
/// @param kind Primitive kind
/// @param tex Texture Index

if (global.__d3dPrimKind != -1) {
	show_debug_message( "ERROR : cannot begin a primitive before end called on previous")
}

global.__d3dPrimKind = argument0;
global.__d3dPrimTex = argument1;
var __uvs = texture_get_uvs(global.__d3dPrimTex);
global.__d3dPrimTexX = __uvs[0];
global.__d3dPrimTexY = __uvs[1];
global.__d3dPrimTexW = __uvs[2] - __uvs[0];
global.__d3dPrimTexH = __uvs[3] - __uvs[1];
vertex_begin( global.__d3dPrimBuffer, global.__d3dPrimVF );