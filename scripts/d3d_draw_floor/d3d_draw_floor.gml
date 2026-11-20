// Feather disable all
/// @desc Draw a 3D floor between two points.
/// @param {real} x1 The starting x coordinate of the floor
/// @param {real} y1 The starting y coordinate of the floor
/// @param {real} z1 The starting z coordinate of the floor
/// @param {real} x2 The ending x coordinate of the floor
/// @param {real} y2 The ending y coordinate of the floor
/// @param {real} z2 The ending z coordinate of the floor
/// @param {pointer.Texture|real} tex The texture to draw the floor with (defaults to -1 for no texture)
/// @param {real} [hrepeat] The number of horizontal texture repetitions (defaults to 1)
/// @param {real} [vrepeat] The number of vertical texture repetitions (defaults to 1)
/// @param {real} [c] The vertex color to draw the floor with (defaults to the current draw color)
/// @param {real} [a] The vertex color to draw the floor with (defaults to the current draw alpha)
function d3d_draw_floor(x1, y1, z1, x2, y2, z2, tex = -1, hrepeat = 1, vrepeat = 1, c = draw_get_colour(), a = draw_get_alpha()) {
    static vertex = Drago3D_Internals.Vertex;
    static format = Drago3D_Internals.format;
    
    static cache = { };
    static archive = ds_priority_create();
    
    var cx = mean(x1, x2);
    var cy = mean(y1, y2);
    var cz = mean(z1, z2);
    var cull_radius = point_distance_3d(cx, cy, cz, x2, y2, z2);
    if (!sphere_is_visible(cx, cy, cz, cull_radius)) {
        return;
    }
    
    var color_word = c | (floor(a * 255) << 24);
    var key = string("{0} {1} {2} {3} {4} {5} {6} {7} {8}", string_format(x1, 1, 4), string_format(y1, 1, 4), string_format(z1, 1, 4), string_format(x2, 1, 4), string_format(y2, 1, 4), string_format(z2, 1, 4), string_format(hrepeat, 1, 4), string(vrepeat, 1, 4), color_word);
    
    var oldrep = gpu_get_texrepeat();
    gpu_set_texrepeat(true);
    
    var vb = cache[$ key];
    if (vb == undefined) {
        vb = vertex_create_buffer();
        vertex_begin(vb, format);
        
        __d3d_floor_internal(vb, x1, y1, z1, x2, y2, z2, hrepeat, vrepeat, c, a);
        
        vertex_end(vb);
        vertex_freeze(vb);
        
        vb = { vb: vb, key: key };
        cache[$ key] = vb;
        ds_priority_add(archive, vb, current_time);
    }
    
    ds_priority_change_priority(archive, vb, current_time);
    vertex_submit(vb.vb, pr_trianglelist, tex);
    
    gpu_set_texrepeat(oldrep);
    
    Drago3D_Internals.Unarchive(archive, cache);
}