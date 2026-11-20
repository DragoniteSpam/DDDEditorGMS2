// Feather disable all
/// @desc Draw a 3D block between two points.
/// @param {real} x1 The starting x coordinate of the block
/// @param {real} y1 The starting y coordinate of the block
/// @param {real} z1 The starting z coordinate of the block
/// @param {real} x2 The ending x coordinate of the block
/// @param {real} y2 The ending y coordinate of the block
/// @param {real} z2 The ending z coordinate of the block
/// @param {pointer.Texture|real} tex The texture to draw the block with (defaults to -1 for no texture)
/// @param {real} [hrepeat] The number of horizontal texture repetitions (defaults to 1)
/// @param {real} [vrepeat] The number of vertical texture repetitions (defaults to 1)
/// @param {real} [c] The vertex color to draw the block with (defaults to the current draw color)
/// @param {real} [a] The vertex color to draw the block with (defaults to the current draw alpha)
function d3d_draw_block(x1, y1, z1, x2, y2, z2, tex = -1, hrepeat = 1, vrepeat = 1, c = draw_get_colour(), a = draw_get_alpha()) {
    static vertex = Drago3D_Internals.Vertex;
    static format = Drago3D_Internals.format;
    
    static cache = { };
    static archive = ds_priority_create();
    
    var wireframe = global.__d3d_wireframe__;
    var color_word = c | (floor(a * 255) << 24);
    var key = string("{0} {1} {2} {3}", string_format(hrepeat, 1, 4), string(vrepeat, 1, 4), color_word, wireframe);
    
    static transform = matrix_build_identity();
    static current_world_matrix = matrix_build_identity();
    static final_world_matrix = matrix_build_identity();
    
    var cx = mean(x1, x2);
    var cy = mean(y1, y2);
    var cz = mean(z1, z2);
    var cull_radius = point_distance_3d(cx, cy, cz, x2, y2, z2);
    if (!sphere_is_visible(cx, cy, cz, cull_radius)) {
        return;
    }
    
    var oldrep = gpu_get_texrepeat();
    gpu_set_texrepeat(true);
    
    var vb = cache[$ key];
    if (vb == undefined) {
        vb = vertex_create_buffer();
        vertex_begin(vb, format);
        
        static cx1 = -0.5;
        static cy1 = -0.5;
        static cz1 = -0.5;
        static cx2 =  0.5;
        static cy2 =  0.5;
        static cz2 =  0.5;
        
        if (wireframe) {
            __d3d_block_internal(vb, cx1, cy1, cz1, cx2, cy2, cz2, hrepeat, vrepeat, c, a);
        } else {
            __d3d_block_internal(vb, cx1, cy1, cz1, cx2, cy2, cz2, hrepeat, vrepeat, c, a);
        }
        
        vertex_end(vb);
        vertex_freeze(vb);
        
        vb = { vb: vb, key: key };
        cache[$ key] = vb;
        ds_priority_add(archive, vb, current_time);
    }
    
    ds_priority_change_priority(archive, vb, current_time);
    
    var sx = x2 - x1;
    var sy = y2 - y1;
    var sz = z2 - z1;
    var cx = mean(x1, x2);
    var cy = mean(y1, y2);
    var cz = mean(z1, z2);
    matrix_build(cx, cy, cz, 0, 0, 0, sx, sy, sz, transform);
    matrix_get(matrix_world, current_world_matrix);
    matrix_multiply(transform, current_world_matrix, final_world_matrix);
    matrix_set(matrix_world, final_world_matrix);
    
    vertex_submit(vb.vb, wireframe ? pr_linelist : pr_trianglelist, tex);
    
    matrix_set(matrix_world, current_world_matrix);
    gpu_set_texrepeat(oldrep);
    
    Drago3D_Internals.Unarchive(archive, cache);
}