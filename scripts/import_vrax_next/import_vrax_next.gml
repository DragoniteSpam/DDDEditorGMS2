/// @param buffer
/// @param grid-size
/// @param name

var data_buffer = argument0;
var grid_size = argument1;
var name = argument2;

var n = buffer_read(data_buffer, T);
var mesh = instance_create_depth(0, 0, 0, DataMesh);

var vbuffer = vertex_create_buffer();
var wbuffer = vertex_create_buffer();
vertex_begin(vbuffer, Camera.vertex_format);
vertex_begin(wbuffer, Camera.vertex_format);

var cdata = c_shape_create();
c_shape_begin_trimesh();

var vc = 0;

var xx = [0, 0, 0];
var yy = [0, 0, 0];
var zz = [0, 0, 0];
var nx, ny, nz, xtex, ytex, color, alpha;

repeat (n) {
    xx[vc] = buffer_read(data_buffer, T);
    yy[vc] = buffer_read(data_buffer, T);
    zz[vc] = buffer_read(data_buffer, T);
    nx = buffer_read(data_buffer, T);
    ny = buffer_read(data_buffer, T);
    nz = buffer_read(data_buffer, T);
    xtex = buffer_read(data_buffer, T) * TILESET_TEXTURE_WIDTH;
    ytex = buffer_read(data_buffer, T) * TILESET_TEXTURE_HEIGHT;
    color = buffer_read(data_buffer, T);
    alpha = buffer_read(data_buffer, T);
    
    vertex_point_complete(vbuffer, xx[vc], yy[vc], zz[vc], nx, ny, nz, xtex, ytex, color, alpha);
    
    vc = (++vc) % 3;
    
    if (vc == 0) {
        vertex_point_line(wbuffer, xx[0], yy[0], zz[0], c_white, 1);
        vertex_point_line(wbuffer, xx[1], yy[1], zz[1], c_white, 1);
        
        vertex_point_line(wbuffer, xx[1], yy[1], zz[1], c_white, 1);
        vertex_point_line(wbuffer, xx[2], yy[2], zz[2], c_white, 1);
        
        vertex_point_line(wbuffer, xx[2], yy[2], zz[2], c_white, 1);
        vertex_point_line(wbuffer, xx[0], yy[0], zz[0], c_white, 1);
        
        c_shape_add_triangle(xx[0], yy[0], zz[0], xx[1], yy[1], zz[1], xx[2], yy[2], zz[2]);
    }
}

if (grid_size > 0) {
    mesh.xmin = buffer_read(data_buffer, T);
    mesh.ymin = buffer_read(data_buffer, T);
    mesh.zmin = buffer_read(data_buffer, T);
    mesh.xmax = buffer_read(data_buffer, T);
    mesh.ymax = buffer_read(data_buffer, T);
    mesh.zmax = buffer_read(data_buffer, T);
}

vertex_end(vbuffer);
vertex_end(wbuffer);
c_shape_end_trimesh(cdata);

mesh.name = name;
var internal_name = name;
while (internal_name_get(internal_name)) {
    internal_name = name + string(irandom(65535));
}
internal_name_set(mesh, internal_name);
mesh.buffer = buffer_create_from_vertex_buffer(vbuffer, buffer_fixed, 1);
mesh.vbuffer = vbuffer;
mesh.wbuffer = wbuffer;
mesh.cshape = cdata;

vertex_freeze(vbuffer);
vertex_freeze(wbuffer);

return mesh;