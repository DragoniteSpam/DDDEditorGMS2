function terrain_create_square(buffer, xx, yy, size, tx, ty, tsize, texel, z0, z1, z2, z3, c0, c1, c2, c3) {
    if (z0 == undefined) z0 = 0;
    if (z1 == undefined) z1 = 0;
    if (z2 == undefined) z2 = 0;
    if (z3 == undefined) z3 = 0;
    if (c0 == undefined) c0 = 0xffffffff;
    if (c1 == undefined) c1 = 0xffffffff;
    if (c2 == undefined) c2 = 0xffffffff;
    if (c3 == undefined) c3 = 0xffffffff;
    
    var a0 = (c0 & 0xff000000) >> 24;
    var a1 = (c1 & 0xff000000) >> 24;
    var a2 = (c2 & 0xff000000) >> 24;
    var a3 = (c3 & 0xff000000) >> 24;
    c0 &= 0x00ffffff;
    c1 &= 0x00ffffff;
    c2 &= 0x00ffffff;
    c3 &= 0x00ffffff;
    
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