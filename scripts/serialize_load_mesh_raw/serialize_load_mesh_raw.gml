/// @param DataMesh

var mesh = argument0;

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