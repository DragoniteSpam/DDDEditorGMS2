/// @param UIButton
/// @param [rebatch?]

var button = argument[0];
var rebatch = (argument_count > 1) ? argument[1] : true;
var mesh = button.root.mesh;

buffer_seek(mesh.buffer, buffer_seek_start, 0);

while (buffer_tell(mesh.buffer) < buffer_get_size(mesh.buffer)) {
    var position = buffer_tell(mesh.buffer);
    var x1 = buffer_peek(mesh.buffer, position, buffer_f32);
    var y1 = buffer_peek(mesh.buffer, position + 4, buffer_f32);
    var z1 = buffer_peek(mesh.buffer, position + 8, buffer_f32);
    var offset = VERTEX_FORMAT_SIZE;
    var x2 = buffer_peek(mesh.buffer, position + offset, buffer_f32);
    var y2 = buffer_peek(mesh.buffer, position + offset + 4, buffer_f32);
    var z2 = buffer_peek(mesh.buffer, position + offset + 8, buffer_f32);
    var offset = VERTEX_FORMAT_SIZE * 2;
    var x3 = buffer_peek(mesh.buffer, position + offset, buffer_f32);
    var y3 = buffer_peek(mesh.buffer, position + offset + 4, buffer_f32);
    var z3 = buffer_peek(mesh.buffer, position + offset + 8, buffer_f32);
    
    var normals = triangle_normal(x1, y1, z1, x2, y2, z2, x3, y3, z3);
    
    buffer_poke(mesh.buffer, position + 12, buffer_f32, normals[0]);
    buffer_poke(mesh.buffer, position + 16, buffer_f32, normals[1]);
    buffer_poke(mesh.buffer, position + 20, buffer_f32, normals[2]);
    var offset = VERTEX_FORMAT_SIZE;
    buffer_poke(mesh.buffer, position + offset + 12, buffer_f32, normals[0]);
    buffer_poke(mesh.buffer, position + offset + 16, buffer_f32, normals[1]);
    buffer_poke(mesh.buffer, position + offset + 20, buffer_f32, normals[2]);
    var offset = VERTEX_FORMAT_SIZE * 2;
    buffer_poke(mesh.buffer, position + offset + 12, buffer_f32, normals[0]);
    buffer_poke(mesh.buffer, position + offset + 16, buffer_f32, normals[1]);
    buffer_poke(mesh.buffer, position + offset + 20, buffer_f32, normals[2]);
    
    buffer_seek(mesh.buffer, buffer_seek_relative, VERTEX_FORMAT_SIZE * 3);
}

buffer_seek(mesh.buffer, buffer_seek_start, 0);

vertex_delete_buffer(mesh.vbuffer);
mesh.vbuffer = vertex_create_buffer_from_buffer(mesh.buffer, Camera.vertex_format);
vertex_freeze(mesh.vbuffer);

if (rebatch) {
    show_message("This has yet to be actually tested properly, seeing as I haven't implemented lighting yet");
    // @todo re-batch everything in the map
}