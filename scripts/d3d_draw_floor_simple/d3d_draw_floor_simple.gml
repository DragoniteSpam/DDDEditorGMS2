// Feather disable all
/// @desc Draw a 3D floor. Skips some of the optional parameters to speed up caching.
/// @param {real} x1 The starting x coordinate of the floor
/// @param {real} y1 The starting y coordinate of the floor
/// @param {real} x2 The ending x coordinate of the floor
/// @param {real} y2 The ending y coordinate of the floor
/// @param {real} z The z coordinate of the floor
/// @param {pointer.Texture|real} tex The texture to draw the floor with (defaults to -1 for no texture)
function d3d_draw_floor_simple(x1, y1, x2, y2, z, tex = -1) {
    static vertex = Drago3D_Internals.Vertex;
    static format = Drago3D_Internals.format;
    
    static vb = undefined;
    
    static transform = matrix_build_identity();
    static current_world_matrix = matrix_build_identity();
    static final_world_matrix = matrix_build_identity();
    
    var cx = mean(x1, x2);
    var cy = mean(y1, y2);
    var cull_radius = point_distance_3d(cx, cy, 0, x2, y2, 0);
    if (!sphere_is_visible(cx, cy, z, cull_radius)) {
        return;
    }
    
    if (vb == undefined) {
        vb = vertex_create_buffer();
        vertex_begin(vb, format);
        
        var cx1 = -0.5;
        var cy1 = -0.5;
        var cx2 = 0.5;
        var cy2 = 0.5;
        var cz = 0;
        
        vertex(vb, cx1, cy1, cz, 0, 0, 1, 0, 0, c_white, 1);
        vertex(vb, cx1, cy2, cz, 0, 0, 1, 0, 1, c_white, 1);
        vertex(vb, cx2, cy2, cz, 0, 0, 1, 1, 1, c_white, 1);
        vertex(vb, cx2, cy2, cz, 0, 0, 1, 1, 1, c_white, 1);
        vertex(vb, cx2, cy1, cz, 0, 0, 1, 1, 0, c_white, 1);
        vertex(vb, cx1, cy1, cz, 0, 0, 1, 0, 0, c_white, 1);
        
        vertex_end(vb);
        vertex_freeze(vb);
    }
    
    var sx = x2 - x1;
    var sy = y2 - y1;
    var cx = mean(x1, x2);
    var cy = mean(y1, y2);
    matrix_build(cx, cy, z, 0, 0, 0, sx, sy, 1, transform);
    matrix_get(matrix_world, current_world_matrix);
    matrix_multiply(transform, current_world_matrix, final_world_matrix);
    matrix_set(matrix_world, final_world_matrix);
    
    vertex_submit(vb, pr_trianglelist, tex);
    
    matrix_set(matrix_world, current_world_matrix);
}