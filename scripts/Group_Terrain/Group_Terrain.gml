#macro terrain_texture_size                                                     sprite_get_height(Stuff.terrain.texture)
#macro terrain_tile_size                                                        (32 / terrain_texture_size)

function terrain_add_to_project() {
    var terrain = Stuff.terrain;
    var scale = terrain.save_scale;
    
    var color_sprite = sprite_create_from_surface(terrain.color.surface, 0, 0, surface_get_width(terrain.color.surface), surface_get_height(terrain.color.surface), false, false, 0, 0);
    var sw = sprite_get_width(color_sprite) / terrain.color_scale;
    var sh = sprite_get_height(color_sprite) / terrain.color_scale;
    
    var vbuff = vertex_create_buffer();
    vertex_begin(vbuff, Stuff.graphics.vertex_format);
    
    for (var i = 0; i < terrain.width - 1; i++) {
        for (var j = 0; j < terrain.height - 1; j++) {
            var z00 = terrain_get_z(terrain, i    , j    );
            var z10 = terrain_get_z(terrain, i + 1, j    );
            var z11 = terrain_get_z(terrain, i + 1, j + 1);
            var z01 = terrain_get_z(terrain, i    , j + 1);
            
            /// @todo: calculate texture coordinates
            var xt00 = undefined;
            var yt00 = undefined;
            var c00 = undefined;
            var xt10 = undefined;
            var yt10 = undefined;
            var c10 = undefined;
            var xt11 = undefined;
            var yt11 = undefined;
            var c11 = undefined;
            var xt01 = undefined;
            var yt01 = undefined;
            var c01 = undefined;
            
            if (terrain.export_all || z00 > 0 || z10 > 0 || z11 > 0) {
                xt00 = 0;
                yt00 = 0;
                c00 = sprite_sample(color_sprite, 0, i / sw, j / sh);
                xt10 = 0;
                yt10 = 0;
                c10 = sprite_sample(color_sprite, 0, (i + 1) / sw, j / sh);
                xt11 = 0;
                yt11 = 0;
                c11 = sprite_sample(color_sprite, 0, (i + 1) / sw, (j + 1) / sh);
                
                var norm = triangle_normal(i, j, z00, i + 1, j, z10, i, j + 1, z11);
                
                vertex_point_complete(vbuff, i     * scale, j     * scale, z00 * scale, norm[0], norm[1], norm[2], xt00, yt00, c00 & 0x00ffffff, (c00 >> 24) / 0xff);
                vertex_point_complete(vbuff, i + 1 * scale, j     * scale, z10 * scale, norm[0], norm[1], norm[2], xt10, yt10, c10 & 0x00ffffff, (c10 >> 24) / 0xff);
                vertex_point_complete(vbuff, i + 1 * scale, j + 1 * scale, z11 * scale, norm[0], norm[1], norm[2], xt11, yt11, c11 & 0x00ffffff, (c11 >> 24) / 0xff);
            }
            
            if (terrain.export_all || z11 > 0 || z01 > 0 || z00 > 0) {
                // 11 and 00 may have already been calculated so theres no point
                // in doing it again!
                if (xt11 == undefined) {
                    xt11 = 0;
                    yt11 = 0;
                    c11 = sprite_sample(color_sprite, 0, (i + 1) / sw, (j + 1) / sh);
                }
                xt01 = 0;
                yt01 = 0;
                c01 = sprite_sample(color_sprite, 0, i / sw, (j + 1) / sh);
                if (xt00 == undefined) {
                    xt00 = 0;
                    yt00 = 0;
                    c00 = sprite_sample(color_sprite, 0, i / sw, j / sh);
                }
                
                var norm = triangle_normal(i + 1, j + 1, z11, i, j + 1, z01, i, j, z00);
                
                vertex_point_complete(vbuff, i + 1 * scale, j + 1 * scale, z11 * scale, norm[0], norm[1], norm[2], xt11, yt11, c11 & 0x00ffffff, (c11 >> 24) / 0xff);
                vertex_point_complete(vbuff, i     * scale, j + 1 * scale, z01 * scale, norm[0], norm[1], norm[2], xt01, yt01, c01 & 0x00ffffff, (c01 >> 24) / 0xff);
                vertex_point_complete(vbuff, i     * scale, j     * scale, z00 * scale, norm[0], norm[1], norm[2], xt00, yt00, c00 & 0x00ffffff, (c00 >> 24) / 0xff);
            }
        }
    }
    
    sprite_delete(color_sprite);
    vertex_end(vbuff);
    
    var mesh = new DataMesh("Terrain");
    mesh_create_submesh(mesh, buffer_create_from_vertex_buffer(vbuff, buffer_fixed, 1), vbuff);
    array_push(Game.meshes, mesh);
    return mesh;
}

function terrain_get_z(terrain, xx, yy) {
    return buffer_peek(terrain.height_data, terrain_get_data_index(terrain, xx, yy), buffer_f32);
}

function terrain_add_z(terrain, xx, yy, value) {
    terrain_set_z(terrain, xx, yy, terrain_get_z(terrain, xx, yy) + value);
}

function terrain_get_data_index(terrain, xx, yy) {
    return (xx * terrain.height + yy) * 4;
}

function terrain_get_vertex_index(terrain, x, y, vertex) {
    // the -1 is annoying and unfortunately comes up a lot. the vertex buffer
    // would is actually one shorter in each dimension than the width and height,
    // because of the way the squares are arranged.
    return VERTEX_SIZE_TERRAIN * ((x * (terrain.height - 1) + y) * terrain.vertices_per_square + vertex);
}

function terrain_refresh_vertex_buffer(terrain) {
    vertex_delete_buffer(terrain.terrain_buffer);
    terrain.terrain_buffer = vertex_create_buffer_from_buffer(terrain.terrain_buffer_data, terrain.vertex_format);
    vertex_freeze(terrain.terrain_buffer);
}

function terrain_create_square(buffer, xx, yy, z00, z10, z11, z01) {
    vertex_position_3d(buffer, xx, yy, z00);
    vertex_position_3d(buffer, xx + 1, yy, z10);
    vertex_position_3d(buffer, xx + 1, yy + 1, z11);
    vertex_position_3d(buffer, xx + 1, yy + 1, z11);
    vertex_position_3d(buffer, xx, yy + 1, z01);
    vertex_position_3d(buffer, xx, yy, z00);
}