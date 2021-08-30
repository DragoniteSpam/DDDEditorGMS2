#macro terrain_texture_size                                                     sprite_get_height(Stuff.terrain.texture)
#macro terrain_texture_texel                                                    (1 / terrain_texture_size)
#macro terrain_tile_size                                                        (32 / terrain_texture_size)

function terrain_add_to_project() {
    var terrain = Stuff.terrain;
    var bytes = buffer_get_size(terrain.terrain_buffer_data);
    var scale = terrain.save_scale;
    
    var fx = sprite_get_width(terrain.texture) / terrain_texture_size;
    var fy = sprite_get_height(terrain.texture) / terrain_texture_size;
    
    var vbuff = vertex_create_buffer();
    var wbuff = vertex_create_buffer();
    vertex_begin(vbuff, Stuff.graphics.vertex_format);
    vertex_begin(wbuff, Stuff.graphics.vertex_format);
    
    for (var i = 0; i < bytes; i += VERTEX_SIZE * 3) {
        var z0 = buffer_peek(terrain.terrain_buffer_data, i + 8, buffer_f32) * scale;
        var z1 = buffer_peek(terrain.terrain_buffer_data, i + 8 + VERTEX_SIZE, buffer_f32) * scale;
        var z2 = buffer_peek(terrain.terrain_buffer_data, i + 8 + VERTEX_SIZE * 2, buffer_f32) * scale;
        
        if (terrain.export_all || z0 > 0 || z1 > 0 || z2 > 0) {
            for (var j = 0; j < VERTEX_SIZE * 3; j = j + VERTEX_SIZE) {
                var xx = buffer_peek(terrain.terrain_buffer_data, j + i, buffer_f32) * scale;
                var yy = buffer_peek(terrain.terrain_buffer_data, j + i + 4, buffer_f32) * scale;
                var zz = buffer_peek(terrain.terrain_buffer_data, j + i + 8, buffer_f32) * scale;
                var nx = buffer_peek(terrain.terrain_buffer_data, j + i + 12, buffer_f32);
                var ny = buffer_peek(terrain.terrain_buffer_data, j + i + 16, buffer_f32);
                var nz = buffer_peek(terrain.terrain_buffer_data, j + i + 20, buffer_f32);
                var xtex = buffer_peek(terrain.terrain_buffer_data, j + i + 24, buffer_f32) * fx;
                var ytex = buffer_peek(terrain.terrain_buffer_data, j + i + 28, buffer_f32) * fy;
                var color = buffer_peek(terrain.terrain_buffer_data, j + i + 32, buffer_u32);
                
                vertex_point_complete(vbuff, xx, yy, zz, nx, ny, nz, xtex, ytex, color & 0x00ffffff, (color >> 24) / 0xff);
            }
        }
    }
    
    vertex_end(vbuff);
    vertex_end(wbuff);
    
    var raw = buffer_create_from_vertex_buffer(vbuff, buffer_fixed, 1);
    
    var mesh = new DataMesh();
    mesh.name = "Terrain";
    mesh_create_submesh(mesh, raw, vbuff, wbuff);
    array_push(Game.meshes, mesh);
    return mesh;
}

function terrain_get_z(terrain, xx, yy) {
    return buffer_peek(terrain.height_data, terrain_get_data_index(terrain, xx, yy), buffer_f32);
}

function terrain_add_color(terrain, xx, yy, color, strength) {
    terrain_set_color(terrain, xx, yy, merge_colour_ds(terrain_get_color(terrain, xx, yy), color, strength));
}

function terrain_add_z(terrain, xx, yy, value) {
    terrain_set_z(terrain, xx, yy, terrain_get_z(terrain, xx, yy) + value);
}

function terrain_get_color(terrain, xx, yy) {
    return buffer_peek(terrain.color_data, terrain_get_color_index(terrain, xx, yy), buffer_u32);
}

function terrain_get_color_index(terrain, xx, yy) {
    return (xx * terrain.height + yy) * 4;
}

function terrain_get_data_index(terrain, xx, yy) {
    return (xx * terrain.height + yy) * 4;
}

function terrain_get_vertex_index(terrain, x, y, vertex) {
    // the -1 is annoying and unfortunately comes up a lot. the vertex buffer
    // would is actually one shorter in each dimension than the width and height,
    // because of the way the squares are arranged.
    return VERTEX_SIZE * ((x * (terrain.height - 1) + y) * terrain.vertices_per_square + vertex);
}

function terrain_refresh_vertex_buffer(terrain) {
    vertex_delete_buffer(terrain.terrain_buffer);
    terrain.terrain_buffer = vertex_create_buffer_from_buffer(terrain.terrain_buffer_data, terrain.vertex_format);
    vertex_freeze(terrain.terrain_buffer);
}

function terrain_set_color(terrain, xx, yy, value) {
    buffer_poke(terrain.color_data, terrain_get_color_index(terrain, xx, yy), buffer_u32, value);
    
    if (xx > 0 && yy > 0) {
        buffer_poke(terrain.terrain_buffer_data, terrain_get_vertex_index(terrain, xx - 1, yy - 1, 2) + 32, buffer_u32, value);
        buffer_poke(terrain.terrain_buffer_data, terrain_get_vertex_index(terrain, xx - 1, yy - 1, 3) + 32, buffer_u32, value);
    }
    
    if (xx < terrain.width && yy > 0) {
        buffer_poke(terrain.terrain_buffer_data, terrain_get_vertex_index(terrain, xx, yy - 1, 4) + 32, buffer_u32, value);
    }
    
    if (xx > 0 && yy < terrain.height) {
        buffer_poke(terrain.terrain_buffer_data, terrain_get_vertex_index(terrain, xx - 1, yy, 1) + 32, buffer_u32, value);
    }
    
    if (xx < terrain.width && yy < terrain.height) {
        buffer_poke(terrain.terrain_buffer_data, terrain_get_vertex_index(terrain, xx, yy, 0) + 32, buffer_u32, value);
        buffer_poke(terrain.terrain_buffer_data, terrain_get_vertex_index(terrain, xx, yy, 5) + 32, buffer_u32, value);
    }
}