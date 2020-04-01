/// @param buffer

var data_buffer = argument0;

var mesh = instance_create_depth(0, 0, 0, DataMesh);

var json = json_decode(buffer_read(data_buffer, buffer_string));
mesh.name = json[? "name"];
var bsize = json[? "size"];
ds_map_destroy(json);

var raw_buffer = buffer_read_buffer(data_buffer, bsize);
var vbuffer = vertex_create_buffer_from_buffer(raw_buffer, Stuff.graphics.vertex_format);
vertex_freeze(vbuffer);

var wbuffer = vertex_create_buffer();
vertex_begin(wbuffer, Stuff.graphics.vertex_format);

var cdata = c_shape_create();
c_shape_begin_trimesh();

for (var i = 0; i < bsize; i += 3 * 40) {
    var x1 = buffer_peek(raw_buffer, i + 000, buffer_f32);
    var y1 = buffer_peek(raw_buffer, i + 004, buffer_f32);
    var z1 = buffer_peek(raw_buffer, i + 008, buffer_f32);
    var x2 = buffer_peek(raw_buffer, i + 040, buffer_f32);
    var y2 = buffer_peek(raw_buffer, i + 044, buffer_f32);
    var z2 = buffer_peek(raw_buffer, i + 048, buffer_f32);
    var x3 = buffer_peek(raw_buffer, i + 080, buffer_f32);
    var y3 = buffer_peek(raw_buffer, i + 084, buffer_f32);
    var z3 = buffer_peek(raw_buffer, i + 088, buffer_f32);
    
    vertex_point_line(wbuffer, x1, y1, z1, c_white, 1);
    vertex_point_line(wbuffer, x2, y2, z2, c_white, 1);
    
    vertex_point_line(wbuffer, x2, y2, z2, c_white, 1);
    vertex_point_line(wbuffer, x3, y3, z3, c_white, 1);
    
    vertex_point_line(wbuffer, x3, y3, z3, c_white, 1);
    vertex_point_line(wbuffer, x1, y1, z1, c_white, 1);
    
    c_shape_add_triangle(x1, y1, z1, x2, y2, z2, x3, y3, z3);
}

vertex_end(wbuffer);
vertex_freeze(wbuffer);
c_shape_end_trimesh(cdata);

mesh_create_submesh(mesh, raw_buffer, vbuffer, wbuffer, undefined, mesh.name);
internal_name_generate(mesh, PREFIX_MESH + string_lettersdigits(mesh.name));
mesh.cshape = cdata;

return mesh;