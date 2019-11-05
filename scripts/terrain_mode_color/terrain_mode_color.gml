/// @param EditorModeTerrain
/// @param cursor-position[]
/// @param [color]

var terrain = argument[0];
var position = argument[1];
var color = (argument_count > 2) ? argument[2] : terrain.paint_color;
var strength = (argument_count > 2) ? 1 : terrain.paint_strength;
var xx = position[vec3.xx];
var yy = position[vec3.yy];
var radius = terrain.radius;

var n = 0;
var coeff = radius * terrain.style_radius_coefficient[terrain.style];

for (var i = max(0, xx - radius + 1); i < min(terrain.width, xx + radius + 1); i++) {
    for (var j = max(0, yy - radius + 1); j < min(terrain.height, yy + radius + 1); j++) {
        var d1 = point_distance(xx + 0.5, yy + 0.5, i + 0.5, j + 0.5);
        var d2 = point_distance(xx + 0.5, yy + 0.5, i + 1.5, j + 0.5);
        var d3 = point_distance(xx + 0.5, yy + 0.5, i + 0.5, j + 1.5);
        var d4 = point_distance(xx + 0.5, yy + 0.5, i + 1.5, j + 1.5);
        if (d1 <= coeff && d2 <= coeff && d3 <= coeff && d4 <= coeff) {
            terrain_add_color(terrain, floor(i), floor(j), color, strength);
            n++;
        }
    }
}

if (n) {
    terrain_refresh_vertex_buffer(terrain);
}