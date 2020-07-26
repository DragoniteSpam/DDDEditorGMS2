/// @param mesh

var mesh = argument0;

for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
    var submesh = mesh.submeshes[| i];
    var buffer = submesh.buffer;
    buffer_seek(buffer, buffer_seek_start, 0);
    
    while (buffer_tell(buffer) < buffer_get_size(buffer)) {
        var position = buffer_tell(buffer);
        
        var normals = triangle_normal(
            // t1
            buffer_peek(buffer, position, buffer_f32),
            buffer_peek(buffer, position + 4, buffer_f32),
            buffer_peek(buffer, position + 8, buffer_f32),
            // t2
            buffer_peek(buffer, position + Stuff.graphics.format_size, buffer_f32),
            buffer_peek(buffer, position + Stuff.graphics.format_size + 4, buffer_f32),
            buffer_peek(buffer, position + Stuff.graphics.format_size + 8, buffer_f32),
            // t3
            buffer_peek(buffer, position + Stuff.graphics.format_size * 2, buffer_f32),
            buffer_peek(buffer, position + Stuff.graphics.format_size * 2 + 4, buffer_f32),
            buffer_peek(buffer, position + Stuff.graphics.format_size * 2 + 8, buffer_f32),
        );
        
        buffer_poke(buffer, position + Stuff.graphics.format_size * 0 + 12, buffer_f32, normals[0]);
        buffer_poke(buffer, position + Stuff.graphics.format_size * 1 + 12, buffer_f32, normals[0]);
        buffer_poke(buffer, position + Stuff.graphics.format_size * 2 + 12, buffer_f32, normals[0]);
        
        buffer_poke(buffer, position + Stuff.graphics.format_size * 0 + 16, buffer_f32, normals[1]);
        buffer_poke(buffer, position + Stuff.graphics.format_size * 1 + 16, buffer_f32, normals[1]);
        buffer_poke(buffer, position + Stuff.graphics.format_size * 2 + 16, buffer_f32, normals[1]);
        
        buffer_poke(buffer, position + Stuff.graphics.format_size * 0 + 20, buffer_f32, normals[2]);
        buffer_poke(buffer, position + Stuff.graphics.format_size * 1 + 20, buffer_f32, normals[2]);
        buffer_poke(buffer, position + Stuff.graphics.format_size * 2 + 20, buffer_f32, normals[2]);
        
        buffer_seek(buffer, buffer_seek_relative, Stuff.graphics.format_size * 3);
    }
    
    buffer_seek(buffer, buffer_seek_start, 0);
    
    vertex_delete_buffer(submesh.vbuffer);
    submesh.vbuffer = vertex_create_buffer_from_buffer(buffer, Stuff.graphics.vertex_format);
    vertex_freeze(submesh.vbuffer);
}