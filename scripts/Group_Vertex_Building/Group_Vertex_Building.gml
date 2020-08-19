function vertex_cube_line(buffer, x, y, z, color, alpha, size) {
    // one
    vertex_point_line(buffer, x - size, y - size, z - size, color, alpha);
    vertex_point_line(buffer, x + size, y - size, z - size, color, alpha);
    vertex_point_line(buffer, x + size, y + size, z - size, color, alpha);
    vertex_point_line(buffer, x + size, y + size, z - size, color, alpha);
    vertex_point_line(buffer, x - size, y + size, z - size, color, alpha);
    vertex_point_line(buffer, x - size, y - size, z - size, color, alpha);
    // two
    vertex_point_line(buffer, x - size, y - size, z + size, color, alpha);
    vertex_point_line(buffer, x + size, y - size, z + size, color, alpha);
    vertex_point_line(buffer, x + size, y + size, z + size, color, alpha);
    vertex_point_line(buffer, x + size, y + size, z + size, color, alpha);
    vertex_point_line(buffer, x - size, y + size, z + size, color, alpha);
    vertex_point_line(buffer, x - size, y - size, z + size, color, alpha);
    // three
    vertex_point_line(buffer, x - size, y - size, z - size, color, alpha);
    vertex_point_line(buffer, x + size, y - size, z - size, color, alpha);
    vertex_point_line(buffer, x + size, y - size, z + size, color, alpha);
    vertex_point_line(buffer, x + size, y - size, z + size, color, alpha);
    vertex_point_line(buffer, x - size, y - size, z + size, color, alpha);
    vertex_point_line(buffer, x - size, y - size, z - size, color, alpha);
    // four
    vertex_point_line(buffer, x - size, y + size, z - size, color, alpha);
    vertex_point_line(buffer, x + size, y + size, z - size, color, alpha);
    vertex_point_line(buffer, x + size, y + size, z + size, color, alpha);
    vertex_point_line(buffer, x + size, y + size, z + size, color, alpha);
    vertex_point_line(buffer, x - size, y + size, z + size, color, alpha);
    vertex_point_line(buffer, x - size, y + size, z - size, color, alpha);
    // five
    vertex_point_line(buffer, x - size, y - size, z - size, color, alpha);
    vertex_point_line(buffer, x - size, y + size, z - size, color, alpha);
    vertex_point_line(buffer, x - size, y + size, z + size, color, alpha);
    vertex_point_line(buffer, x - size, y + size, z + size, color, alpha);
    vertex_point_line(buffer, x - size, y - size, z + size, color, alpha);
    vertex_point_line(buffer, x - size, y - size, z - size, color, alpha);
    // six
    vertex_point_line(buffer, x + size, y - size, z - size, color, alpha);
    vertex_point_line(buffer, x + size, y + size, z - size, color, alpha);
    vertex_point_line(buffer, x + size, y + size, z + size, color, alpha);
    vertex_point_line(buffer, x + size, y + size, z + size, color, alpha);
    vertex_point_line(buffer, x + size, y - size, z + size, color, alpha);
    vertex_point_line(buffer, x + size, y - size, z - size, color, alpha);
}

function vertex_point_basic(buffer, x, y, z, nx, ny, nz, xtex, ytex, color, alpha) {
    vertex_position_3d(buffer, x, y, z);
    vertex_normal(buffer, nx, ny, nz);
    vertex_texcoord(buffer, xtex, ytex);
    vertex_colour(buffer, color, alpha);
}

function vertex_point_complete(buffer, x, y, z, nx, ny, nz, xtex, ytex, color, alpha) {
    vertex_position_3d(buffer, x, y, z);
    vertex_normal(buffer, nx, ny, nz);
    vertex_texcoord(buffer, xtex, ytex);
    vertex_colour(buffer, color, alpha);
    // todo this - extra 32 bits for whatever you want
    vertex_colour(buffer, 0, 0);
}

function vertex_point_complete_raw(buffer, x, y, z, nx, ny, nz, xtex, ytex, color, alpha) {
    buffer_write(buffer, buffer_f32, x);
    buffer_write(buffer, buffer_f32, y);
    buffer_write(buffer, buffer_f32, z);
    buffer_write(buffer, buffer_f32, nx);
    buffer_write(buffer, buffer_f32, ny);
    buffer_write(buffer, buffer_f32, nz);
    buffer_write(buffer, buffer_f32, xtex);
    buffer_write(buffer, buffer_f32, ytex);
    buffer_write(buffer, buffer_u32, (floor(alpha * 0xff) << 24) | colour_reverse(color));
    buffer_write(buffer, buffer_u32, 0x00000000);
}

function vertex_point_line(buffer, x, y, z, color, alpha) {
    vertex_position_3d(buffer, x, y, z);
    vertex_normal(buffer, 0, 0, 1);
    vertex_texcoord(buffer, 0, 0);
    vertex_colour(buffer, color, alpha);
    vertex_colour(buffer, 0x000000, 1);
}

function vertex_point_line_raw(buffer, x, y, z, color, alpha) {
    buffer_write(buffer, buffer_f32, x);
    buffer_write(buffer, buffer_f32, y);
    buffer_write(buffer, buffer_f32, z);
    buffer_write(buffer, buffer_f32, 0);
    buffer_write(buffer, buffer_f32, 0);
    buffer_write(buffer, buffer_f32, 1);
    buffer_write(buffer, buffer_f32, 0);
    buffer_write(buffer, buffer_f32, 0);
    buffer_write(buffer, buffer_u32, (floor(alpha * 0xff) << 24) | colour_reverse(color));
    buffer_write(buffer, buffer_u32, 0x00000000);
}