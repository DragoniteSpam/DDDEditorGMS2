/// @param buffer
/// @param x
/// @param y
/// @param size
/// @param tx
/// @param ty
/// @param tsize
/// @param texel
/// @param [z0]
/// @param [z1]
/// @param [z2]
/// @param [z3]
/// @param [c0]
/// @param [c1]
/// @param [c2]
/// @param [c3]
function terrain_create_square() {

	var buffer = argument[0];
	var xx = argument[1];
	var yy = argument[2];
	var size = argument[3];
	var tx = argument[4];
	var ty = argument[5];
	var tsize = argument[6];
	var texel = argument[7];
	var z0 = (argument_count > 8) ? argument[8] : 0;
	var z1 = (argument_count > 9) ? argument[9] : 0;
	var z2 = (argument_count > 10) ? argument[10] : 0;
	var z3 = (argument_count > 11) ? argument[11] : 0;
	var c0 = (argument_count > 12) ? argument[12] : 0xffffffff;
	var c1 = (argument_count > 13) ? argument[13] : 0xffffffff;
	var c2 = (argument_count > 14) ? argument[14] : 0xffffffff;
	var c3 = (argument_count > 15) ? argument[15] : 0xffffffff;

	var a0 = (c0 & 0xff000000) >> 24;
	var a1 = (c1 & 0xff000000) >> 24;
	var a2 = (c2 & 0xff000000) >> 24;
	var a3 = (c3 & 0xff000000) >> 24;
	var c0 = c0 & 0x00ffffff;
	var c1 = c1 & 0x00ffffff;
	var c2 = c2 & 0x00ffffff;
	var c3 = c3 & 0x00ffffff;

	// (0, 0)
	vertex_position_3d(buffer, xx, yy, z0);
	vertex_normal(buffer, 0, 0, 1);
	vertex_texcoord(buffer, tx + texel, ty + texel);
	vertex_colour(buffer, c0, a0);
	// (1, 0)
	vertex_position_3d(buffer, xx + size, yy, z1);
	vertex_normal(buffer, 0, 0, 1);
	vertex_texcoord(buffer, tx + tsize - texel, ty + texel);
	vertex_colour(buffer, c1, a1);
	// (1, 1)
	vertex_position_3d(buffer, xx + size, yy + size, z2);
	vertex_normal(buffer, 0, 0, 1);
	vertex_texcoord(buffer, tx + tsize - texel, ty + tsize - texel);
	vertex_colour(buffer, c2, a2);
	// (1, 1)
	vertex_position_3d(buffer, xx + size, yy + size, z2);
	vertex_normal(buffer, 0, 0, 1);
	vertex_texcoord(buffer, tx + tsize - texel, ty + tsize - texel);
	vertex_colour(buffer, c2, a2);
	// (0, 1)
	vertex_position_3d(buffer, xx, yy + size, z3);
	vertex_normal(buffer, 0, 0, 1);
	vertex_texcoord(buffer, tx + texel, ty + tsize - texel);
	vertex_colour(buffer, c3, a3);
	// (0, 0)
	vertex_position_3d(buffer, xx, yy, z0);
	vertex_normal(buffer, 0, 0, 1);
	vertex_texcoord(buffer, tx + texel, ty + texel);
	vertex_colour(buffer, c0, a0);


}
