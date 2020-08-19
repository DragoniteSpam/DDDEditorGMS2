/// @param buffer
/// @param grid-size
/// @param name
function import_vrax_next() {

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

    var vc = 0;

    var xx = [0, 0, 0];
    var yy = [0, 0, 0];
    var zz = [0, 0, 0];
    var nx, ny, nz, xtex, ytex, color, alpha;

    repeat (n) {
        xx[vc] = buffer_read(data_buffer, buffer_f32);
        yy[vc] = buffer_read(data_buffer, buffer_f32);
        zz[vc] = buffer_read(data_buffer, buffer_f32);
        nx = buffer_read(data_buffer, buffer_f32);
        ny = buffer_read(data_buffer, buffer_f32);
        nz = buffer_read(data_buffer, buffer_f32);
        xtex = buffer_read(data_buffer, buffer_f32);
        ytex = buffer_read(data_buffer, buffer_f32);
        color = buffer_read(data_buffer, buffer_f32);
        alpha = buffer_read(data_buffer, buffer_f32);
    
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


}
