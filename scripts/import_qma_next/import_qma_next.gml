/// @param buffer
/// @param grid-size
/// @param name

var data_buffer = argument[0];
var grid_size = argument[1];
var name = argument[2];

var n = buffer_read(data_buffer, buffer_f32);
var mesh = instance_create_depth(0, 0, 0, DataMesh);

var vbuffer = vertex_create_buffer();
var wbuffer = vertex_create_buffer();
vertex_begin(vbuffer, Stuff.graphics.vertex_format);
vertex_begin(wbuffer, Stuff.graphics.vertex_format);

var cdata = c_shape_create();
c_shape_begin_trimesh();

var bsize = buffer_read(data_buffer, buffer_u32);
var raw_buffer = buffer_read_buffer(data_buffer, bsize);

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

if (grid_size > 0) {
    mesh.xmin = buffer_read(data_buffer, buffer_f32);
    mesh.ymin = buffer_read(data_buffer, buffer_f32);
    mesh.zmin = buffer_read(data_buffer, buffer_f32);
    mesh.xmax = buffer_read(data_buffer, buffer_f32);
    mesh.ymax = buffer_read(data_buffer, buffer_f32);
    mesh.zmax = buffer_read(data_buffer, buffer_f32);
}
data_mesh_recalculate_bounds(mesh);

vertex_end(vbuffer);
vertex_end(wbuffer);
c_shape_end_trimesh(cdata);

mesh.name = name;
internal_name_generate(mesh, PREFIX_MESH + string_lettersdigits(name));
mesh.cshape = cdata;

mesh_create_submesh(mesh, buffer_create_from_vertex_buffer(vbuffer, buffer_fixed, 1), vbuffer, wbuffer, undefined, name);
vertex_freeze(vbuffer);
vertex_freeze(wbuffer);

return mesh;