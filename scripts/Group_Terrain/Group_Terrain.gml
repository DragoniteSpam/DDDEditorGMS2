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