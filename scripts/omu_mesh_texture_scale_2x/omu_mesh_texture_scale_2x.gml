/// @param UIButton

var button = argument[0];
var mesh = button.root.mesh;

for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
    var submesh = mesh.submeshes[| i];
    var buffer = submesh.buffer;
    buffer_seek(buffer, buffer_seek_start, 0);
    
    while (buffer_tell(buffer) < buffer_get_size(buffer)) {
        var position = buffer_tell(buffer);
        
        var tu = buffer_peek(buffer, position + 24, buffer_f32);
        var tv = buffer_peek(buffer, position + 28, buffer_f32);
        buffer_poke(buffer, position + 24, buffer_f32, tu * 2);
        buffer_poke(buffer, position + 28, buffer_f32, tv * 2);
        
        buffer_seek(buffer, buffer_seek_relative, Stuff.graphics.format_size);
    }
    
    buffer_seek(buffer, buffer_seek_start, 0);
    
    vertex_delete_buffer(submesh.vbuffer);
    submesh.vbuffer = vertex_create_buffer_from_buffer(buffer, Stuff.graphics.vertex_format);
    vertex_freeze(submesh.vbuffer);
    
    // no actual vertex data has changed, so we can keep the wbuffer
}

show_message("you will need to re-batch");
// @todo re-batch everything in the map