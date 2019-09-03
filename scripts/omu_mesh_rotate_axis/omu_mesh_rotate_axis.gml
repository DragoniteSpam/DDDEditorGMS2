/// @param UIButton

var button = argument[0];
var mesh = button.root.mesh;

buffer_seek(mesh.buffer, buffer_seek_start, 0);

var tangle = dcos(Stuff.setting_normal_threshold);
var normal_map = ds_map_create();

while (buffer_tell(mesh.buffer) < buffer_get_size(mesh.buffer)) {
    var position = buffer_tell(mesh.buffer);
    
    var xx = buffer_peek(mesh.buffer, position, buffer_f32);
    var yy = buffer_peek(mesh.buffer, position + 4, buffer_f32);
    var zz = buffer_peek(mesh.buffer, position + 8, buffer_f32);
    // lol
    buffer_poke(mesh.buffer, position, buffer_f32, yy);
    buffer_poke(mesh.buffer, position + 4, buffer_f32, zz);
    buffer_poke(mesh.buffer, position + 8, buffer_f32, xx);
    
    buffer_seek(mesh.buffer, buffer_seek_relative, VERTEX_FORMAT_SIZE);
}

buffer_seek(mesh.buffer, buffer_seek_start, 0);

vertex_delete_buffer(mesh.vbuffer);
mesh.vbuffer = vertex_create_buffer_from_buffer(mesh.buffer, Camera.vertex_format);
vertex_freeze(mesh.vbuffer);

vertex_delete_buffer(mesh.wbuffer);
mesh.wbuffer = vertex_create_buffer();
vertex_begin(mesh.wbuffer, Camera.vertex_format_line);
while (buffer_tell(mesh.buffer) < buffer_get_size(mesh.buffer)) {
    var x1 = buffer_read(mesh.buffer, buffer_f32);
    var y1 = buffer_read(mesh.buffer, buffer_f32);
    var z1 = buffer_read(mesh.buffer, buffer_f32);
    buffer_seek(mesh.buffer, buffer_seek_relative, VERTEX_FORMAT_SIZE - 12);
    var x2 = buffer_read(mesh.buffer, buffer_f32);
    var y2 = buffer_read(mesh.buffer, buffer_f32);
    var z2 = buffer_read(mesh.buffer, buffer_f32);
    buffer_seek(mesh.buffer, buffer_seek_relative, VERTEX_FORMAT_SIZE - 12);
    var x3 = buffer_read(mesh.buffer, buffer_f32);
    var y3 = buffer_read(mesh.buffer, buffer_f32);
    var z3 = buffer_read(mesh.buffer, buffer_f32);
    buffer_seek(mesh.buffer, buffer_seek_relative, VERTEX_FORMAT_SIZE - 12);
    
    vertex_point_line(mesh.wbuffer, x1, y1, z1, c_white, 1);
    vertex_point_line(mesh.wbuffer, x2, y2, z2, c_white, 1);
    
    vertex_point_line(mesh.wbuffer, x2, y2, z2, c_white, 1);
    vertex_point_line(mesh.wbuffer, x3, y3, z3, c_white, 1);
    
    vertex_point_line(mesh.wbuffer, x3, y3, z3, c_white, 1);
    vertex_point_line(mesh.wbuffer, x1, y1, z1, c_white, 1);
}
vertex_end(mesh.wbuffer);
vertex_freeze(mesh.wbuffer);

show_message("you will need to re-batch");
// @todo re-batch everything in the map