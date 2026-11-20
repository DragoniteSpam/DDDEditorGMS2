// Feather disable all
/// @desc Function Description
/// @param {real} x1 The starting x coordinate of the cylinder
/// @param {real} y1 The starting y coordinate of the cylinder
/// @param {real} z1 The starting z coordinate of the cylinder
/// @param {real} x2 The ending x coordinate of the cylinder
/// @param {real} y2 The ending y coordinate of the cylinder
/// @param {real} z2 The ending z coordinate of the cylinder
/// @param {pointer.Texture|real} tex The texture to draw the cylinder with (defaults to -1 for no texture)
/// @param {real} [hrepeat] The number of horizontal texture repetitions (defaults to 1)
/// @param {real} [vrepeat] The number of vertical texture repetitions (defaults to 1)
/// @param {bool} [closed] Whether to draw the top and bottom surfaces or not (defaults to true)
/// @param {real} [steps] The number of steps to draw the cylinder with; higher values produce smooth shapes but are more expensive (defaults to 32)
/// @param {real} [c1] The vertex color to draw the beginning of the cylinder with (defaults to the current draw color)
/// @param {real} [a1] The vertex alpha to draw the beginning of the cylinder with (defaults to the current draw alpha)
/// @param {real} [c2] The vertex color to draw the end of the cylinder with (defaults to c1)
/// @param {real} [a2] The vertex alpha to draw the end of the cylinder with (defaults to a1)
function d3d_draw_cylinder(x1, y1, z1, x2, y2, z2, tex = -1, hrepeat = 1, vrepeat = 1, closed = true, steps = 32, c1 = draw_get_colour(), a1 = draw_get_alpha(), c2 = c1, a2 = a1) {
    static vertex = Drago3D_Internals.Vertex;
    static format = Drago3D_Internals.format;
    
    static cache = { };
    static cache_closed = { };
    static cache_closed_bottom = { };
    static archive = ds_priority_create();
    
    static r = 0.5;
    static nr = -r;
    
    static transform = matrix_build_identity();
    static current_world_matrix = matrix_build_identity();
    static final_transform = matrix_build_identity();
    static transform_scale = matrix_build_identity();
    static transform_translate = matrix_build_identity();
    static transform_intermediate = matrix_build_identity();
    
    var cx = mean(x1, x2);
    var cy = mean(y1, y2);
    var cz = mean(z1, z2);
    var cull_radius = point_distance_3d(x1, y1, z1, x2, y2, z2);
    if (!sphere_is_visible(cx, cy, cz, cull_radius)) {
        return;
    }
    
    steps = clamp(steps, 3, 128);
    
    var color_word_1 = c1 | floor(a1 * 255) << 16;
    var color_word_2 = c2 | floor(a2 * 255) << 16;
    var key = string("{0} {1} {2} {3} {4}", string_format(hrepeat, 1, 4), string(vrepeat, 1, 4), steps, color_word_1, color_word_2);
    
    var oldrep = gpu_get_texrepeat();
    gpu_set_texrepeat(true);
    
    var vb = cache[$ key];
    if (vb == undefined) {
        vb = vertex_create_buffer();
        vertex_begin(vb, format);
        
        // Create sin and cos tables
        var cc = array_create(steps + 1);
        var ss = array_create(steps + 1);
        var hsteps = hrepeat / steps;
        
        for(var i = 0; i <= steps; i++) {
        	var rad = (i * 2.0 * pi) / steps;
        	cc[i] = cos(rad);
        	ss[i] = sin(rad);
        }
        
        var rows = floor((steps + 1) / 2);
        var vrows = vrepeat / rows;
        
        for(var i = steps; i >= 0; i--) {
            var cci = cc[i];
            var ssi = ss[i];
        	vertex(vb, cci * r, ssi * r, nr, cci, ssi, 0, hsteps * i, vrepeat, c1, a1);
        	vertex(vb, cci * r, ssi * r,  r, cci, ssi, 0, hsteps * i, 0, c2, a2);
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
    matrix_multiply(transform, current_world_matrix, final_transform);
    matrix_set(matrix_world, final_transform);
    vertex_submit(vb.vb, pr_trianglestrip, tex);
    
    if (closed) {
        var cc, ss;
        var hsteps = hrepeat / steps;
        vb = cache_closed[$ key];
        if (vb == undefined) {
            vb = vertex_create_buffer();
            vertex_begin(vb, format);
            
            // Create sin and cos tables
            cc = array_create(steps + 1);
            ss = array_create(steps + 1);
            for(var i = 0; i <= steps; i++) {
            	var rad = (i * 2.0 * pi) / steps;
            	cc[i] = cos(rad) * 0.5;
            	ss[i] = sin(rad) * 0.5;
            }
            
            for(var i = 0; i < steps; i++) {
                var cci = cc[i];
                var ssi = ss[i];
                var cci2 = cc[i + 1];
                var ssi2 = ss[i + 1];
                vertex(vb, 0, 0, 0, 0, 0, 1, 0.5, 0.5, c1, a1);
            	vertex(vb, cci, ssi, 0, 0, 0, 1, 0.5 + cci * hrepeat, 0.5 + ssi * vrepeat, c1, a1);
            	vertex(vb, cci2, ssi2, 0, 0, 0, 1, 0.5 + cci2 * hrepeat, 0.5 + ssi2 * vrepeat, c1, a1);
            }
        	
            vertex_end(vb);
            vertex_freeze(vb);
            
            vb = { vb: vb, key: key };
            cache_closed[$ key] = vb;
            ds_priority_add(archive, vb, current_time);
        }
        
        ds_priority_change_priority(archive, vb, current_time);
        
        matrix_build(0, 0, sz / 2, 0, 0, 0, sx, sy, 1, transform_scale);
        matrix_build(cx, cy, cz, 0, 0, 0, 1, 1, 1, transform_translate);
        matrix_multiply(transform_scale, transform_translate, transform_intermediate);
        matrix_multiply(transform, transform_intermediate, final_transform)
        matrix_set(matrix_world, final_transform);
        vertex_submit(vb.vb, pr_trianglelist, tex);
        
        // winding direction...
        vb = cache_closed_bottom[$ key];
        if (vb == undefined) {
            vb = vertex_create_buffer();
            vertex_begin(vb, format);
            
            for(var i = steps; i > 0; i--) {
                var cci = cc[i];
                var ssi = ss[i];
                var cci2 = cc[i - 1];
                var ssi2 = ss[i - 1];
                vertex(vb, 0, 0, 0, 0, 0, 1, 0.5, 0.5, c2, a2);
            	vertex(vb, cci, ssi, 0, 0, 0, 1, 0.5 + cci * hrepeat, 0.5 + ssi * vrepeat, c2, a2);
            	vertex(vb, cci2, ssi2, 0, 0, 0, 1, 0.5 + cci2 * hrepeat, 0.5 + ssi2 * vrepeat, c2, a2);
            }
        	
            vertex_end(vb);
            vertex_freeze(vb);
            
            vb = { vb: vb, key: key };
            cache_closed_bottom[$ key] = vb;
            ds_priority_add(archive, vb, current_time);
        }
        
        ds_priority_change_priority(archive, vb, current_time);
        
        matrix_build(0, 0, -sz / 2, 0, 0, 0, sx, sy, 1, transform_scale);
        matrix_multiply(transform_scale, transform_translate, transform_intermediate);
        matrix_multiply(transform, transform_intermediate, final_transform)
        matrix_set(matrix_world, final_transform);
        vertex_submit(vb.vb, pr_trianglelist, tex);
    }
    
    matrix_set(matrix_world, current_world_matrix);
    gpu_set_texrepeat(oldrep);
    
    Drago3D_Internals.Unarchive(archive, cache);
    Drago3D_Internals.Unarchive(archive, cache_closed);
    Drago3D_Internals.Unarchive(archive, cache_closed_bottom);
}