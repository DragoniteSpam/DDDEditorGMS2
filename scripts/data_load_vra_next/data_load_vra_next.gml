/// @param buffer
/// @param grid-size
// the array that is returned takes the form of
// [vbuff, buff, xmin, ymin, zmin, xmax, ymax, zmax]

var n = buffer_read(argument0, T);

var buffer = vertex_create_buffer();
var buffer_wire = vertex_create_buffer();
var data = buffer_create(n * 4 * 10, buffer_fixed, 4);
vertex_begin(buffer, Camera.vertex_format);
vertex_begin(buffer_wire, Camera.vertex_format_line);

var cdata = c_shape_create();
c_shape_begin_trimesh();

var vc = 0;

var xx = array_create(3);
var yy = array_create(3);
var zz = array_create(3);
var nx, ny, nz, xtex, ytex, color, alpha;

repeat(n) {
    xx[vc] = buffer_read(argument0, T);
    yy[vc] = buffer_read(argument0, T);
    zz[vc] = buffer_read(argument0, T);
    nx = buffer_read(argument0, T);
    ny = buffer_read(argument0, T);
    nz = buffer_read(argument0, T);
    xtex = buffer_read(argument0, T) * TILESET_TEXTURE_WIDTH;
    ytex = buffer_read(argument0, T) * TILESET_TEXTURE_HEIGHT;
    color = buffer_read(argument0, T);
    alpha = buffer_read(argument0, T);
    
    vertex_point_complete(buffer, xx[vc], yy[vc], zz[vc], nx, ny, nz, xtex, ytex, color, alpha);
    buffer_point_complete(data, xx[vc], yy[vc], zz[vc], nx, ny, nz, xtex, ytex, color, alpha);
    
    vc = (++vc) % 3;
    
    if (vc == 0) {
        vertex_point_line(buffer_wire, xx[0], yy[0], zz[0], c_white, 1);
        vertex_point_line(buffer_wire, xx[1], yy[1], zz[1], c_white, 1);
        
        vertex_point_line(buffer_wire, xx[1], yy[1], zz[1], c_white, 1);
        vertex_point_line(buffer_wire, xx[2], yy[2], zz[2], c_white, 1);
        
        vertex_point_line(buffer_wire, xx[2], yy[2], zz[2], c_white, 1);
        vertex_point_line(buffer_wire, xx[0], yy[0], zz[0], c_white, 1);
        
        c_shape_add_triangle(xx[0], yy[0], zz[0], xx[1], yy[1], zz[1], xx[2], yy[2], zz[2]);
    }
}

var xmin = 0;
var ymin = 0;
var zmin = 0;
var xmax = 0;
var ymax = 0;
var zmax = 0;

if (argument1 > 0) {
    xmin = buffer_read(argument0, T);
    ymin = buffer_read(argument0, T);
    zmin = buffer_read(argument0, T);
    xmax = buffer_read(argument0, T);
    ymax = buffer_read(argument0, T);
    zmax = buffer_read(argument0, T);
}

vertex_end(buffer);
vertex_end(buffer_wire);

c_shape_end_trimesh(cdata);

// it's really annoying, but you can't convert frozen vertex buffers
// to normal buffers, and you need to do that to access the information
// inside the vertex buffer in order to batch static objects together.

// for now save both the vertex buffer and the ordinary buffer. it uses
// more memory but the only alternative that i can think of is reloading
// all of the meshes every time you enter a new map, which i don't think
// anyone wants to do.

// in any case it turns out reading data from vertex buffers is haaaaard.

// todo ask TheSnidr about this, and about how to read data out of a
// converted vertex buffer, because thatll probably be easier?

vertex_freeze(buffer);
vertex_freeze(buffer_wire);

return [buffer, buffer_wire, cdata, data, xmin, ymin, zmin, xmax, ymax, zmax, 0, 0, 0];

enum MeshArrayData {
    VBUFF,
    VBUFF_WIREFRAME,
    CDATA,
    DATA,
    XMIN,
    YMIN,
    ZMIN,
    XMAX,
    YMAX,
    ZMAX,
    PASSAGE,
    FLAGS,
    TAGS
}