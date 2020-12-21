function terrain_mode_color(terrain, position, color, strength) {
    if (color == undefined) color = terrain.paint_color;
    if (strength == undefined) strength = terrain.paint_strength;
    
    var radius = terrain.radius;
    
    var n = 0;
    var coeff = radius * terrain.style_radius_coefficient[terrain.style];
    
    for (var i = max(0, position.x - radius + 1); i < min(terrain.width, position.x + radius + 1); i++) {
        for (var j = max(0, position.y - radius + 1); j < min(terrain.height, position.y + radius + 1); j++) {
            var d1 = point_distance(position.x + 0.5, position.y + 0.5, i + 0.5, j + 0.5);
            var d2 = point_distance(position.x + 0.5, position.y + 0.5, i + 1.5, j + 0.5);
            var d3 = point_distance(position.x + 0.5, position.y + 0.5, i + 0.5, j + 1.5);
            var d4 = point_distance(position.x + 0.5, position.y + 0.5, i + 1.5, j + 1.5);
            if (d1 <= coeff && d2 <= coeff && d3 <= coeff && d4 <= coeff) {
                terrain_add_color(terrain, floor(i), floor(j), color, strength);
                n++;
            }
        }
    }
    
    if (n) {
        terrain_refresh_vertex_buffer(terrain);
    }
}