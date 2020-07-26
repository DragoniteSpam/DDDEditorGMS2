/// @param mesh

var mesh = argument0;

for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
    var submesh = mesh.submeshes[| i];
    var buffer = submesh.buffer;
    buffer_seek(buffer, buffer_seek_start, 0);
    
    while (buffer_tell(buffer) < buffer_get_size(buffer)) {
        var position = buffer_tell(buffer);
        
        buffer_poke(buffer, position + VERTEX_SIZE * 0 + 12, buffer_f32, 0);
        buffer_poke(buffer, position + VERTEX_SIZE * 1 + 12, buffer_f32, 0);
        buffer_poke(buffer, position + VERTEX_SIZE * 2 + 12, buffer_f32, 1);
        
        buffer_poke(buffer, position + VERTEX_SIZE * 0 + 16, buffer_f32, 0);
        buffer_poke(buffer, position + VERTEX_SIZE * 1 + 16, buffer_f32, 0);
        buffer_poke(buffer, position + VERTEX_SIZE * 2 + 16, buffer_f32, 1);
        
        buffer_poke(buffer, position + VERTEX_SIZE * 0 + 20, buffer_f32, 0);
        buffer_poke(buffer, position + VERTEX_SIZE * 1 + 20, buffer_f32, 0);
        buffer_poke(buffer, position + VERTEX_SIZE * 2 + 20, buffer_f32, 1);
        
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE * 3);
    }
    
    buffer_seek(buffer, buffer_seek_start, 0);
    
    vertex_delete_buffer(submesh.vbuffer);
    submesh.vbuffer = vertex_create_buffer_from_buffer(buffer, Stuff.graphics.vertex_format);
    vertex_freeze(submesh.vbuffer);
}