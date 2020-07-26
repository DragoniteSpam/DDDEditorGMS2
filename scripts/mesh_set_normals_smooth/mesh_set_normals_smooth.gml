/// @param mesh
/// @param threshold

var mesh = argument0;
var threshold = dcos(argument1);

// probably not super efficient but
if (threshold < 1) {
    mesh_set_normals_flat(mesh);
}

for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
    var submesh = mesh.submeshes[| i];
    var buffer = submesh.buffer;
    buffer_seek(buffer, buffer_seek_start, 0);
    var normal_map = ds_map_create();
    
    while (buffer_tell(buffer) < buffer_get_size(buffer)) {
        var position = buffer_tell(buffer);
        
        var xx = [
            buffer_peek(buffer, position, buffer_f32),
            buffer_peek(buffer, position + VERTEX_SIZE, buffer_f32),
            buffer_peek(buffer, position + VERTEX_SIZE * 2, buffer_f32)
        ];
        var yy = [
            buffer_peek(buffer, position + 4, buffer_f32),
            buffer_peek(buffer, position + VERTEX_SIZE + 4, buffer_f32),
            buffer_peek(buffer, position + VERTEX_SIZE * 2 + 4, buffer_f32)
        ];
        var zz = [
            buffer_peek(buffer, position + 8, buffer_f32),
            buffer_peek(buffer, position + VERTEX_SIZE + 8, buffer_f32),
            buffer_peek(buffer, position + VERTEX_SIZE * 2 + 8, buffer_f32)
        ];
        
        var normals = triangle_normal(xx[0], yy[0], zz[0], xx[1], yy[1], zz[1], xx[2], yy[2], zz[2]);
        
        for (var i = 0; i < 3; i++) {
            var key = string(xx[i]) + "," + string(yy[i]) + "," + string(zz[i]);
            if (ds_map_exists(normal_map, key)) {
                var existing = normal_map[? key];
                normal_map[? key] = [existing[0] + normals[0], existing[1] + normals[1], existing[2] + normals[2]];
            } else {
                normal_map[? key] = normals;
            }
        }
        
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE * 3);
    }
    
    buffer_seek(buffer, buffer_seek_start, 0);
    
    while (buffer_tell(buffer) < buffer_get_size(buffer)) {
        var position = buffer_tell(buffer);
        
        var xx = buffer_peek(buffer, position, buffer_f32);
        var yy = buffer_peek(buffer, position + 4, buffer_f32);
        var zz = buffer_peek(buffer, position + 8, buffer_f32);
        var nx = buffer_peek(buffer, position + 12, buffer_f32);
        var ny = buffer_peek(buffer, position + 16, buffer_f32);
        var nz = buffer_peek(buffer, position + 20, buffer_f32);
        var key = string(xx) + "," + string(yy) + "," + string(zz);
        
        var n = vector3_normalize(normal_map[? key]);
        var angle_dot = dot_product_3d(n[0], n[1], n[2], nx, ny, nz);
        if (angle_dot > threshold) {
            buffer_poke(buffer, position + 12, buffer_f32, n[0]);
            buffer_poke(buffer, position + 16, buffer_f32, n[1]);
            buffer_poke(buffer, position + 20, buffer_f32, n[2]);
        }
        
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE);
    }
    
    ds_map_destroy(normal_map);
    vertex_delete_buffer(submesh.vbuffer);
    submesh.vbuffer = vertex_create_buffer_from_buffer(buffer, Stuff.graphics.vertex_format);
    vertex_freeze(submesh.vbuffer);
}