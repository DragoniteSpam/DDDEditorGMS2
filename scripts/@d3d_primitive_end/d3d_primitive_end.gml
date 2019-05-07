/// @description d3d - end the primitive stream

if (global.__d3dPrimKind != -1) {

	vertex_end( global.__d3dPrimBuffer );
	vertex_submit( global.__d3dPrimBuffer, global.__d3dPrimKind, global.__d3dPrimTex );

	// mark this as finished
	global.__d3dPrimKind = -1;
} else {
	show_debug_message( "d3d_primitive_end :: with no d3d_primitive_begin ");
}
