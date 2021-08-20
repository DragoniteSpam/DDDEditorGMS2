function terrain_create_square(buffer, xx, yy, size, tx, ty, tsize, texel, z00, z10, z11, z01, c00, c10, c11, c01) {
    if (z00 == undefined) z00 = 0;
    if (z10 == undefined) z10 = 0;
    if (z11 == undefined) z11 = 0;
    if (z01 == undefined) z01 = 0;
    if (c00 == undefined) c00 = 0xffffffff;
    if (c10 == undefined) c10 = 0xffffffff;
    if (c11 == undefined) c11 = 0xffffffff;
    if (c01 == undefined) c01 = 0xffffffff;
    
    var a00 = (c00 & 0xff000000) >> 24;
    var a10 = (c10 & 0xff000000) >> 24;
    var a11 = (c11 & 0xff000000) >> 24;
    var a01 = (c01 & 0xff000000) >> 24;
    c00 &= 0x00ffffff;
    c10 &= 0x00ffffff;
    c11 &= 0x00ffffff;
    c01 &= 0x00ffffff;
    
    // (0, 0)
    vertex_position_3d(buffer, xx, yy, z00);
    vertex_normal(buffer, 0, 0, 1);
    vertex_texcoord(buffer, tx + texel, ty + texel);
    vertex_colour(buffer, c00, a00);
    // (1, 0)
    vertex_position_3d(buffer, xx + size, yy, z10);
    vertex_normal(buffer, 0, 0, 1);
    vertex_texcoord(buffer, tx + tsize - texel, ty + texel);
    vertex_colour(buffer, c10, a10);
    // (1, 1)
    vertex_position_3d(buffer, xx + size, yy + size, z11);
    vertex_normal(buffer, 0, 0, 1);
    vertex_texcoord(buffer, tx + tsize - texel, ty + tsize - texel);
    vertex_colour(buffer, c11, a11);
    // (1, 1)
    vertex_position_3d(buffer, xx + size, yy + size, z11);
    vertex_normal(buffer, 0, 0, 1);
    vertex_texcoord(buffer, tx + tsize - texel, ty + tsize - texel);
    vertex_colour(buffer, c11, a11);
    // (0, 1)
    vertex_position_3d(buffer, xx, yy + size, z01);
    vertex_normal(buffer, 0, 0, 1);
    vertex_texcoord(buffer, tx + texel, ty + tsize - texel);
    vertex_colour(buffer, c01, a01);
    // (0, 0)
    vertex_position_3d(buffer, xx, yy, z00);
    vertex_normal(buffer, 0, 0, 1);
    vertex_texcoord(buffer, tx + texel, ty + texel);
    vertex_colour(buffer, c00, a00);
}