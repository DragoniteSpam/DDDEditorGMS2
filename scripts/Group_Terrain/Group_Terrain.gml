#macro terrain_texture_size                                                     sprite_get_height(Stuff.terrain.texture)
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
    
    for (var i = 0; i < bytes; i += VERTEX_SIZE_TERRAIN * 3) {
        var x1 = buffer_peek(terrain.terrain_buffer_data, i + VERTEX_SIZE_TERRAIN * 0 + 0, buffer_f32);
        var y1 = buffer_peek(terrain.terrain_buffer_data, i + VERTEX_SIZE_TERRAIN * 0 + 4, buffer_f32);
        var z1 = buffer_peek(terrain.terrain_buffer_data, i + VERTEX_SIZE_TERRAIN * 0 + 8, buffer_f32);
        var x2 = buffer_peek(terrain.terrain_buffer_data, i + VERTEX_SIZE_TERRAIN * 1 + 0, buffer_f32);
        var y2 = buffer_peek(terrain.terrain_buffer_data, i + VERTEX_SIZE_TERRAIN * 1 + 4, buffer_f32);
        var z2 = buffer_peek(terrain.terrain_buffer_data, i + VERTEX_SIZE_TERRAIN * 1 + 8, buffer_f32);
        var x3 = buffer_peek(terrain.terrain_buffer_data, i + VERTEX_SIZE_TERRAIN * 2 + 0, buffer_f32);
        var y3 = buffer_peek(terrain.terrain_buffer_data, i + VERTEX_SIZE_TERRAIN * 2 + 4, buffer_f32);
        var z3 = buffer_peek(terrain.terrain_buffer_data, i + VERTEX_SIZE_TERRAIN * 2 + 8, buffer_f32);
        
        if (terrain.export_all || z1 > 0 || z2 > 0 || z3 > 0) {
            for (var j = 0; j < VERTEX_SIZE * 3; j = j + VERTEX_SIZE) {
                var xtex1 = 0;
                var ytex1 = 0;
                var nx1 = 0;
                var ny1 = 0;
                var nz1 = 0;
                var c1 = c_white;
                var a1 = 1;
                var xtex2 = 0;
                var ytex2 = 0;
                var nx2 = 0;
                var ny2 = 0;
                var nz2 = 0;
                var c2 = c_white;
                var a2 = 1;
                var xtex3 = 0;
                var ytex3 = 0;
                var nx3 = 0;
                var ny3 = 0;
                var nz3 = 0;
                var c3 = c_white;
                var a3 = 1;
                
                vertex_point_complete(vbuff, x1, y1, z1, nx1, ny1, nz1, xtex1, ytex1, c1, a1);
                vertex_point_complete(vbuff, x2, y2, z2, nx2, ny2, nz2, xtex2, ytex2, c2, a2);
                vertex_point_complete(vbuff, x3, y3, z3, nx3, ny3, nz3, xtex3, ytex3, c3, a3);
                
                vertex_point_line(wbuff, x1, y1, z1, c_white, 1); vertex_point_line(wbuff, x2, y2, z2, c_white, 1);
                vertex_point_line(wbuff, x2, y2, z2, c_white, 1); vertex_point_line(wbuff, x3, y3, z3, c_white, 1);
                vertex_point_line(wbuff, x3, y3, z3, c_white, 1); vertex_point_line(wbuff, x1, y1, z1, c_white, 1);
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