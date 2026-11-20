// Feather disable all
/// @desc Draw a 3D ellipsoid. Skips some of the optional parameters to speed up caching.
/// @param {real} x1 The starting x coordinate of the ellipsoid
/// @param {real} y1 The starting y coordinate of the ellipsoid
/// @param {real} z1 The starting z coordinate of the ellipsoid
/// @param {real} x2 The ending x coordinate of the ellipsoid
/// @param {real} y2 The ending y coordinate of the ellipsoid
/// @param {real} z2 The ending z coordinate of the ellipsoid
/// @param {pointer.Texture|real} tex The texture to draw the ellipsoid with (defaults to -1 for no texture)
function d3d_draw_ellipsoid_simple(x1, y1, z1, x2, y2, z2, tex = -1) {
    static vertex = Drago3D_Internals.Vertex;
    static format = Drago3D_Internals.format;
    
    static transform = matrix_build_identity();
    static current_world_matrix = matrix_build_identity();
    static final_world_matrix = matrix_build_identity();
    
    static vb = undefined;
    
    var cx = mean(x1, x2);
    var cy = mean(y1, y2);
    var cz = mean(z1, z2);
    var cull_radius = point_distance_3d(cx, cy, cz, x2, y2, z2);
    if (!sphere_is_visible(cx, cy, cz, cull_radius)) {
        return;
    }
    
    if (vb == undefined) {
        vb = vertex_create_buffer();
        vertex_begin(vb, format);
        
        static steps = 32;
        var r = 0.5;
        
        // Create sin and cos tables
        var cc = array_create(steps + 1);
        var ss = array_create(steps + 1);
        
        for(var i = 0; i <= steps; i++) {
        	var rad = (i * 2.0 * pi) / steps;
        	cc[i] = cos(rad);
        	ss[i] = sin(rad);
        }
        
        var rows = floor((steps + 1) / 2);
        var vrows = 1 / rows;
        
        for(var j = 0; j < rows; j++) {
            var jvr1 = j * vrows;
            var jvr2 = (j + 1) * vrows;
            
        	var row1rad = (j * pi) / rows;
        	var row2rad = ((j + 1) * pi) / rows;
        	var rh1 = cos(row1rad);
        	var rd1 = sin(row1rad);
        	var rh2 = cos(row2rad);
        	var rd2 = sin(row2rad);
            
            var rrd1 = r * rd1;
            var rrd2 = r * rd2;
            var rrh1 = r * rh1;
            var rrh2 = r * rh2;
	        
        	for(var i = 0; i <= steps; i++) {
                var f = i / steps;
                var cci = cc[i];
                var ssi = ss[i];
        		vertex(vb, rrd1 * cci, rrd1 * ssi, rrh1, rd1 * cci, rd1 * ssi, rh1, f, jvr1, c_white, 1);
        		vertex(vb, rrd2 * cci, rrd2 * ssi, rrh2, rd2 * cci, rd2 * ssi, rh2, f, jvr2, c_white, 1);
        	}
        }
        
        vertex_end(vb);
        vertex_freeze(vb);
    }
    
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
    
    vertex_submit(vb, pr_trianglestrip, tex);
    
    matrix_set(matrix_world, current_world_matrix);
}