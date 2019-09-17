with (Camera) {
    /*
     * mild spaghetti - grid with origin in the corner
     */
	
	var map = Stuff.active_map;
	var map_contents = map.contents;
	
    if (grid) vertex_delete_buffer(grid);
    
    grid = vertex_create_buffer();
    
    vertex_begin(grid, vertex_format);
    
    // grid
    for (var i = 0; i <= map.xx; i++) {
        vertex_point_line(grid, i * TILE_WIDTH, 0, 0, c_white, 1);
        vertex_point_line(grid, i * TILE_WIDTH, map.yy * TILE_HEIGHT, 0, c_white, 1);
    }
    
    for (var i = 0; i <= map.yy; i++) {
        vertex_point_line(grid, 0, i * TILE_HEIGHT, 0, c_white, 1);
        vertex_point_line(grid, map.xx * TILE_WIDTH, i * TILE_HEIGHT, 0, c_white, 1);
    }
    
    // axes
    vertex_point_line(grid, 0, 0, 0, c_red, 1);
    vertex_point_line(grid, MILLION, 0, 0, c_red, 1);
    
    vertex_point_line(grid, 0, 0, 0, c_green, 1);
    vertex_point_line(grid, 0, MILLION, 0, c_green, 1);
    
    vertex_point_line(grid, 0, 0, 0, c_blue, 1);
    vertex_point_line(grid, 0, 0, MILLION, c_blue, 1);
    
    vertex_end(grid);
    vertex_freeze(grid);

    /*
     * mild spaghetti - grid with origin in the center
     */

    if (grid_centered) vertex_delete_buffer(grid_centered);
    
    grid_centered = vertex_create_buffer();
    
    vertex_begin(grid_centered, vertex_format);
    
    // grid
    var xx = map.xx / 2;
    var yy = map.yy / 2;
    
    for (var i = -xx; i <= xx; i++) {
        if (i != 0) {
            vertex_point_line(grid_centered, i * TILE_WIDTH, -yy * TILE_HEIGHT, 0, c_white, 1);
            vertex_point_line(grid_centered, i * TILE_WIDTH, yy * TILE_HEIGHT, 0, c_white, 1);
        }
    }
    
    for (var i = -yy; i <= yy; i++) {
        if (i != 0) {
            vertex_point_line(grid_centered, -xx * TILE_WIDTH, i * TILE_HEIGHT, 0, c_white, 1);
            vertex_point_line(grid_centered, xx * TILE_WIDTH, i * TILE_HEIGHT, 0, c_white, 1);
        }
    }
    
    // axes
    vertex_point_line(grid_centered, -MILLION, 0, 0, c_red, 1);
    vertex_point_line(grid_centered, MILLION, 0, 0, c_red, 1);
    
    vertex_point_line(grid_centered, 0, -MILLION, 0, c_green, 1);
    vertex_point_line(grid_centered, 0, MILLION, 0, c_green, 1);
    
    vertex_point_line(grid_centered, 0, 0, 0, c_blue, 1);
    vertex_point_line(grid_centered, 0, 0, MILLION, c_blue, 1);
    
    vertex_end(grid_centered);
    vertex_freeze(grid_centered);

    /*
     * mild spaghetti - grid with origin in the center
     */

    if (grid_sphere) vertex_delete_buffer(grid_sphere);
    
    grid_sphere = vertex_create_buffer();
    
    vertex_begin(grid_sphere, vertex_format);
    
    var radius = 16;
    var segments = 16;
    var magenta = 0xff00ff;
    
    for (var i = 0; i < segments; i++) {
        var angle = i * 360 / segments;
        var angle_next = (i + 1) * 360 / segments;
        for (var j = 0; j < segments / 2; j++) {
            var arc = j * 2 * 180 / segments - 90;
            var arc2 = (j + 1) * 2 * 180 / segments - 90;
            var point = matrix_transform_vertex(matrix_build(0, 0, 0, 0, 0, angle, radius, radius, radius), dcos(arc), 0, dsin(arc));
            var point2 = matrix_transform_vertex(matrix_build(0, 0, 0, 0, 0, angle, radius, radius, radius), dcos(arc2), 0, dsin(arc2));
            
            var point_next = matrix_transform_vertex(matrix_build(0, 0, 0, 0, 0, angle_next, radius, radius, radius), dcos(arc), 0, dsin(arc));
            var point2_next = matrix_transform_vertex(matrix_build(0, 0, 0, 0, 0, angle_next, radius, radius, radius), dcos(arc2), 0, dsin(arc2));
            
            vertex_point_line(grid_sphere, point[vec3.xx], point[vec3.yy], point[vec3.zz], magenta, 1);
            vertex_point_line(grid_sphere, point2[vec3.xx], point2[vec3.yy], point2[vec3.zz], magenta, 1);
            vertex_point_line(grid_sphere, point[vec3.xx], point[vec3.yy], point[vec3.zz], magenta, 1);
            vertex_point_line(grid_sphere, point_next[vec3.xx], point_next[vec3.yy], point_next[vec3.zz], magenta, 1);
            vertex_point_line(grid_sphere, point2[vec3.xx], point2[vec3.yy], point2[vec3.zz], magenta, 1);
            vertex_point_line(grid_sphere, point2_next[vec3.xx], point2_next[vec3.yy], point2_next[vec3.zz], magenta, 1);
            vertex_point_line(grid_sphere, point[vec3.xx], point[vec3.yy], point[vec3.zz], magenta, 1);
            vertex_point_line(grid_sphere, point2_next[vec3.xx], point2_next[vec3.yy], point2_next[vec3.zz], magenta, 1);
            vertex_point_line(grid_sphere, point2[vec3.xx], point2[vec3.yy], point2[vec3.zz], magenta, 1);
            vertex_point_line(grid_sphere, point_next[vec3.xx], point_next[vec3.yy], point_next[vec3.zz], magenta, 1);
        }
    }
    
    vertex_end(grid_sphere);
    vertex_freeze(grid_sphere);
}