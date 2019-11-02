/// @param EditorModeTerrain
/// @param cursor-position[]
/// @param [color]

var terrain = argument[0];
var position = argument[1];
var color = (argument_count > 2) ? argument[2] : terrain.paint_color;
var strength = (argument_count > 2) ? 1 : terrain.paint_strength;
var xx = floor(position[vec3.xx]);
var yy = floor(position[vec3.yy]);
var radius = floor(terrain.radius);

var n = 0;

for (var i = max(0, xx - radius + 1); i < min(terrain.width - 1, xx + radius + 1); i++) {
    for (var j = max(0, yy - radius + 1); j < min(terrain.height - 1, yy + radius + 1); j++) {
        var d = point_distance(xx, yy, i + 0.5, j + 0.5);
        if (d <= radius * terrain.style_radius_coefficient[terrain.style]) {
            terrain_add_color(terrain, i, j, color, strength);
            n++;
        }
    }
}

if (n) {
    terrain_refresh_vertex_buffer(terrain);
}