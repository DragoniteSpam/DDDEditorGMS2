/// @param UIButton

var button = argument[0];
var mesh = button.root.mesh;

for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
    var submesh = mesh.submeshes[| i];
    var buffer = submesh.buffer;
    buffer_seek(buffer, buffer_seek_start, 0);
    
    while (buffer_tell(buffer) < buffer_get_size(buffer)) {
        var position = buffer_tell(buffer);
        
        var xx = buffer_peek(buffer, position, buffer_f32);
        var yy = buffer_peek(buffer, position + 4, buffer_f32);
        var zz = buffer_peek(buffer, position + 8, buffer_f32);
        // lol
        buffer_poke(buffer, position, buffer_f32, yy);
        buffer_poke(buffer, position + 4, buffer_f32, zz);
        buffer_poke(buffer, position + 8, buffer_f32, xx);
        
        buffer_seek(buffer, buffer_seek_relative, Stuff.graphics.format_size);
    }
    
    buffer_seek(buffer, buffer_seek_start, 0);
    
    vertex_delete_buffer(submesh.vbuffer);
    submesh.vbuffer = vertex_create_buffer_from_buffer(buffer, Stuff.graphics.vertex_format);
    vertex_freeze(submesh.vbuffer);

    vertex_delete_buffer(submesh.wbuffer);
    var wbuffer = vertex_create_buffer();
    submesh.wbuffer = wbuffer;
    vertex_begin(wbuffer, Stuff.graphics.vertex_format);
    while (buffer_tell(buffer) < buffer_get_size(buffer)) {
        var x1 = buffer_read(buffer, buffer_f32);
        var y1 = buffer_read(buffer, buffer_f32);
        var z1 = buffer_read(buffer, buffer_f32);
        buffer_seek(buffer, buffer_seek_relative, Stuff.graphics.format_size - 12);
        var x2 = buffer_read(buffer, buffer_f32);
        var y2 = buffer_read(buffer, buffer_f32);
        var z2 = buffer_read(buffer, buffer_f32);
        buffer_seek(buffer, buffer_seek_relative, Stuff.graphics.format_size - 12);
        var x3 = buffer_read(buffer, buffer_f32);
        var y3 = buffer_read(buffer, buffer_f32);
        var z3 = buffer_read(buffer, buffer_f32);
        buffer_seek(buffer, buffer_seek_relative, Stuff.graphics.format_size - 12);
    
        vertex_point_line(wbuffer, x1, y1, z1, c_white, 1);
        vertex_point_line(wbuffer, x2, y2, z2, c_white, 1);
    
        vertex_point_line(wbuffer, x2, y2, z2, c_white, 1);
        vertex_point_line(wbuffer, x3, y3, z3, c_white, 1);
    
        vertex_point_line(wbuffer, x3, y3, z3, c_white, 1);
        vertex_point_line(wbuffer, x1, y1, z1, c_white, 1);
    }
    vertex_end(wbuffer);
    vertex_freeze(wbuffer);
}

show_message("you will need to re-batch");
// @todo re-batch everything in the map