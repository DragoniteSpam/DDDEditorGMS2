/// @param DataMesh

var mesh = argument0;

var vc = 0;
var xx = [0, 0, 0];
var yy = [0, 0, 0];
var zz = [0, 0, 0];
var nx, ny, nz, xtex, ytex, color;

for (var i = 0; i < ds_list_size(mesh.buffers); i++) {
    proto_guid_set(mesh, i, proto_guid_generate(mesh));
    var buffer = mesh.buffers[| i];
    
    var vbuffer = vertex_create_buffer_from_buffer(buffer, Stuff.graphics.vertex_format);
    vertex_freeze(vbuffer);
    ds_list_add(mesh.vbuffers, vbuffer);
    
    var wbuffer = vertex_create_buffer();
    vertex_begin(wbuffer, Stuff.graphics.vertex_format);
    ds_list_add(mesh.wbuffers, wbuffer);
    
    if (i == 0) {
        mesh.cshape = c_shape_create();
        c_shape_begin_trimesh();
    }
    
    // this is all quite annoying, but fortunately you won't need it in the game
    buffer_seek(buffer, buffer_seek_start, 0);
    while (buffer_tell(buffer) < buffer_get_size(buffer)) {
        xx[vc] = buffer_read(buffer, buffer_f32);
        yy[vc] = buffer_read(buffer, buffer_f32);
        zz[vc] = buffer_read(buffer, buffer_f32);
        nx = buffer_read(buffer, buffer_f32);
        ny = buffer_read(buffer, buffer_f32);
        nz = buffer_read(buffer, buffer_f32);
        xtex = buffer_read(buffer, buffer_f32);
        ytex = buffer_read(buffer, buffer_f32);
        color = buffer_read(buffer, buffer_u32);
        buffer_read(buffer, buffer_u32);
        
        vc = ++vc % 3;
        
        if (vc == 0) {
            vertex_point_line(wbuffer, xx[0], yy[0], zz[0], c_white, 1);
            vertex_point_line(wbuffer, xx[1], yy[1], zz[1], c_white, 1);
            
            vertex_point_line(wbuffer, xx[1], yy[1], zz[1], c_white, 1);
            vertex_point_line(wbuffer, xx[2], yy[2], zz[2], c_white, 1);
            
            vertex_point_line(wbuffer, xx[2], yy[2], zz[2], c_white, 1);
            vertex_point_line(wbuffer, xx[0], yy[0], zz[0], c_white, 1);
            
            if (i == 0) {
                c_shape_add_triangle(xx[0], yy[0], zz[0], xx[1], yy[1], zz[1], xx[2], yy[2], zz[2]);
            }
        }
    }
    
    vertex_end(wbuffer);
    vertex_freeze(wbuffer);
    buffer_seek(buffer, buffer_seek_start, 0);
    
    if (i == 0) {
        c_shape_end_trimesh(mesh.cshape);
    }
}