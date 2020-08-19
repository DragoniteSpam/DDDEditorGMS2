/// @param EditorModeTerrain
/// @param cursor-position[]
function terrain_mode_texture(argument0, argument1) {

    var terrain = argument0;
    var position = argument1;
    var xx = position[vec3.xx];
    var yy = position[vec3.yy];
    var radius = terrain.radius;
    var xtex = terrain.tile_brush_x;
    var ytex = terrain.tile_brush_y;

    var n = 0;
    var coeff = radius * terrain.style_radius_coefficient[terrain.style];

    for (var i = max(0, xx - radius + 1); i < min(terrain.width, xx + radius + 1); i++) {
        for (var j = max(0, yy - radius + 1); j < min(terrain.height, yy + radius + 1); j++) {
            var d1 = point_distance(xx + 0.5, yy + 0.5, i + 0.5, j + 0.5);
            var d2 = point_distance(xx + 0.5, yy + 0.5, i + 1.5, j + 0.5);
            var d3 = point_distance(xx + 0.5, yy + 0.5, i + 0.5, j + 1.5);
            var d4 = point_distance(xx + 0.5, yy + 0.5, i + 1.5, j + 1.5);
            if (d1 <= coeff && d2 <= coeff && d3 <= coeff && d4 <= coeff) {
                terrain_set_texture(terrain, floor(i), floor(j), xtex, ytex);
                n++;
            }
        }
    }

    if (n) {
        terrain_refresh_vertex_buffer(terrain);
    }


}
