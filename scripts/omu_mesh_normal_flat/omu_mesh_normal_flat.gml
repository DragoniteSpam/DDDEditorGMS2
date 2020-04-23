/// @param UIButton
/// @param [rebatch?]

var button = argument[0];
var rebatch = (argument_count > 1) ? argument[1] : true;
var mesh = button.root.mesh;

for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
    var submesh = mesh.submeshes[| i];
    var buffer = submesh.buffer;
    buffer_seek(buffer, buffer_seek_start, 0);
    
    while (buffer_tell(buffer) < buffer_get_size(buffer)) {
        var position = buffer_tell(buffer);
        var x1 = buffer_peek(buffer, position, buffer_f32);
        var y1 = buffer_peek(buffer, position + 4, buffer_f32);
        var z1 = buffer_peek(buffer, position + 8, buffer_f32);
        var offset = Stuff.graphics.format_size;
        var x2 = buffer_peek(buffer, position + offset, buffer_f32);
        var y2 = buffer_peek(buffer, position + offset + 4, buffer_f32);
        var z2 = buffer_peek(buffer, position + offset + 8, buffer_f32);
        var offset = Stuff.graphics.format_size * 2;
        var x3 = buffer_peek(buffer, position + offset, buffer_f32);
        var y3 = buffer_peek(buffer, position + offset + 4, buffer_f32);
        var z3 = buffer_peek(buffer, position + offset + 8, buffer_f32);
        
        var normals = triangle_normal(x1, y1, z1, x2, y2, z2, x3, y3, z3);
        
        buffer_poke(buffer, position + 12, buffer_f32, normals[0]);
        buffer_poke(buffer, position + 16, buffer_f32, normals[1]);
        buffer_poke(buffer, position + 20, buffer_f32, normals[2]);
        var offset = Stuff.graphics.format_size;
        buffer_poke(buffer, position + offset + 12, buffer_f32, normals[0]);
        buffer_poke(buffer, position + offset + 16, buffer_f32, normals[1]);
        buffer_poke(buffer, position + offset + 20, buffer_f32, normals[2]);
        var offset = Stuff.graphics.format_size * 2;
        buffer_poke(buffer, position + offset + 12, buffer_f32, normals[0]);
        buffer_poke(buffer, position + offset + 16, buffer_f32, normals[1]);
        buffer_poke(buffer, position + offset + 20, buffer_f32, normals[2]);
        
        buffer_seek(buffer, buffer_seek_relative, Stuff.graphics.format_size * 3);
    }
    
    buffer_seek(buffer, buffer_seek_start, 0);
    
    vertex_delete_buffer(submesh.vbuffer);
    submesh.vbuffer = vertex_create_buffer_from_buffer(buffer, Stuff.graphics.vertex_format);
    vertex_freeze(submesh.vbuffer);
}

if (rebatch) {
    batch_again();
}