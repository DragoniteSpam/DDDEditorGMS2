// Feather disable all
/// @desc Draw a 3D wall. Skips some of the optional parameters to speed up caching.
/// @param {real} x1 The starting x coordinate of the wall
/// @param {real} y1 The starting y coordinate of the wall
/// @param {real} z1 The starting z coordinate of the wall
/// @param {real} x2 The ending x coordinate of the wall
/// @param {real} y2 The ending y coordinate of the wall
/// @param {real} z2 The ending z coordinate of the wall
/// @param {pointer.Texture|real} tex The texture to draw the wall with (defaults to -1 for no texture)
function d3d_draw_wall_simple(x1, y1, z1, x2, y2, z2, tex = -1) {
    static vertex = Drago3D_Internals.Vertex;
    static format = Drago3D_Internals.format;
    
    static cache = { };
    
    var cx = mean(x1, x2);
    var cy = mean(y1, y2);
    var cz = mean(z1, z2);
    var cull_radius = point_distance_3d(cx, cy, cz, x2, y2, z2);
    if (!sphere_is_visible(cx, cy, cz, cull_radius)) {
        return;
    }
    
    // not quite as simple because you cant assume the wall is going to be drawn on a flat plane
    // i might do some matrix tricks later to get around that, but meh
    var key = string("{0} {1} {2} {3} {4} {5}", string_format(x1, 1, 4), string_format(y1, 1, 4), string_format(z1, 1, 4), string_format(x2, 1, 4), string_format(y2, 1, 4), string_format(z2, 1, 4));
    
    var vb = cache[$ key];
    if (vb == undefined) {
        vb = vertex_create_buffer();
        vertex_begin(vb, format);
        
        var xdiff = x2 - x1;
        var ydiff = y2 - y1;
        
        var l = point_distance(xdiff, ydiff, 0, 0);
        var nx = ydiff / l;
        var ny = -xdiff / l;
        
        vertex(vb, x1, y1, z1, nx, ny, 0, 0, 0, c_white, 1);
        vertex(vb, x2, y2, z1, nx, ny, 0, 1, 0, c_white, 1);
        vertex(vb, x2, y2, z2, nx, ny, 0, 1, 1, c_white, 1);
        vertex(vb, x2, y2, z2, nx, ny, 0, 1, 1, c_white, 1);
        vertex(vb, x1, y1, z2, nx, ny, 0, 0, 1, c_white, 1);
        vertex(vb, x1, y1, z1, nx, ny, 0, 0, 0, c_white, 1);
        
        vertex_end(vb);
        vertex_freeze(vb);
        
        cache[$ key] = vb;
    }
    
    vertex_submit(vb, pr_trianglelist, tex);
}