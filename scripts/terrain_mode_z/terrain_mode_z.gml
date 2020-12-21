function terrain_mode_z(terrain, position, dir) {
    var radius = terrain.radius;
    
    var t = 0;
    var coeff = radius * terrain.style_radius_coefficient[terrain.style];
    var list_range = ds_list_create();
    
    for (var i = max(0, position.x - radius + 1); i < min(terrain.width, position.x + radius + 1); i++) {
        for (var j = max(0, position.y - radius + 1); j < min(terrain.height, position.y + radius + 1); j++) {
            var d1 = point_distance(position.x + 0.5, position.y + 0.5, i + 0.5, j + 0.5);
            var d2 = point_distance(position.x + 0.5, position.y + 0.5, i + 1.5, j + 0.5);
            var d3 = point_distance(position.x + 0.5, position.y + 0.5, i + 0.5, j + 1.5);
            var d4 = point_distance(position.x + 0.5, position.y + 0.5, i + 1.5, j + 1.5);
            if (d1 <= coeff && d2 <= coeff && d3 <= coeff && d4 <= coeff) {
                t = t + terrain_get_z(terrain, floor(i), floor(j));
                ds_list_add(list_range, [floor(i), floor(j), mean(d1, d2, d3, d4)]);
            }
        }
    }
    
    var avg = t / ds_list_size(list_range);
    
    for (var i = 0; i < ds_list_size(list_range); i++) {
        var coordinates = list_range[| i];
        terrain.submode_equation[terrain.submode](terrain, coordinates[vec3.position.x], coordinates[vec3.position.y], dir, avg, coordinates[vec3.zz]);
    }
    
    for (var i = 0; i < ds_list_size(list_range); i++) {
        var coordinates = list_range[| i];
        terrain_set_normals(terrain, coordinates[vec3.position.x], coordinates[vec3.position.y]);
    }
    
    if (!ds_list_empty(list_range)) {
        terrain_refresh_vertex_buffer(terrain);
    }
    
    ds_list_destroy(list_range);
}