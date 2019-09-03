/// @param buffer
/// @param version

var buffer = argument0;
var version = argument1;

ds_list_clear_instances(Stuff.all_meshes);

var n_meshes = buffer_read(buffer, buffer_u32);

repeat (n_meshes) {
    var mesh = instance_create_depth(0, 0, 0, DataMesh);
    serialize_load_generic(buffer, mesh, version);
    
    var size = buffer_read(buffer, buffer_u32);
    mesh.buffer = buffer_read_buffer(buffer, size);
    mesh.vbuffer = vertex_create_buffer_from_buffer(mesh.buffer, Camera.vertex_format);
    
    mesh.cshape = c_shape_create();
    c_shape_begin_trimesh();
    mesh.wbuffer = vertex_create_buffer();
    vertex_begin(mesh.wbuffer, Camera.vertex_format);
    
    mesh.xmin = buffer_read(buffer, buffer_f32);
    mesh.ymin = buffer_read(buffer, buffer_f32);
    mesh.zmin = buffer_read(buffer, buffer_f32);
    mesh.xmax = buffer_read(buffer, buffer_f32);
    mesh.ymax = buffer_read(buffer, buffer_f32);
    mesh.zmax = buffer_read(buffer, buffer_f32);
    
    mesh.passage = buffer_read(buffer, buffer_u8);
    mesh.tags = buffer_read(buffer, buffer_u8);
        
    var vc = 0;
    
    var xx = [0, 0, 0];
    var yy = [0, 0, 0];
    var zz = [0, 0, 0];
    var nx, ny, nz, xtex, ytex, color;
    
    // this is all quite annoying, but fortunately you won't need it in the game
    while (buffer_tell(mesh.buffer) < buffer_get_size(mesh.buffer)) {
        xx[vc] = buffer_read(mesh.buffer, buffer_f32);
        yy[vc] = buffer_read(mesh.buffer, buffer_f32);
        zz[vc] = buffer_read(mesh.buffer, buffer_f32);
        nx = buffer_read(mesh.buffer, buffer_f32);
        ny = buffer_read(mesh.buffer, buffer_f32);
        nz = buffer_read(mesh.buffer, buffer_f32);
        xtex = buffer_read(mesh.buffer, buffer_f32);
        ytex = buffer_read(mesh.buffer, buffer_f32);
        color = buffer_read(mesh.buffer, buffer_u32);
        buffer_read(mesh.buffer, buffer_u32);
        
        vc = ++vc % 3;
    
        if (vc == 0) {
            vertex_point_line(mesh.wbuffer, xx[0], yy[0], zz[0], c_white, 1);
            vertex_point_line(mesh.wbuffer, xx[1], yy[1], zz[1], c_white, 1);
        
            vertex_point_line(mesh.wbuffer, xx[1], yy[1], zz[1], c_white, 1);
            vertex_point_line(mesh.wbuffer, xx[2], yy[2], zz[2], c_white, 1);
        
            vertex_point_line(mesh.wbuffer, xx[2], yy[2], zz[2], c_white, 1);
            vertex_point_line(mesh.wbuffer, xx[0], yy[0], zz[0], c_white, 1);
        
            c_shape_add_triangle(xx[0], yy[0], zz[0], xx[1], yy[1], zz[1], xx[2], yy[2], zz[2]);
        }
    }
    
    c_shape_end_trimesh(mesh.cshape);
    vertex_end(mesh.wbuffer);
    buffer_seek(mesh.buffer, buffer_seek_start, 0);
}