/// @param EditorModeTerrain
/// @param cursor-position[]
/// @param direction

var terrain = argument0;
var position = argument1;
var dir = argument2;
var xx = floor(position[vec3.xx]);
var yy = floor(position[vec3.yy]);
var radius = terrain.radius;

var n = 0;
var t = 0;

for (var i = max(0, xx - radius); i < min(terrain.width - 1, xx + radius); i++) {
    for (var j = max(0, yy - radius); j < min(terrain.height - 1, yy + radius); j++) {
        var d = point_distance(xx, yy, i, j);
        if (d <= radius * terrain.style_radius_coefficient[terrain.style]) {
            t = t + terrain_get_z(terrain, i, j);
            n++;
        }
    }
}

var avg = t / n;

for (var i = max(0, xx - radius); i < min(terrain.width - 1, xx + radius); i++) {
    for (var j = max(0, yy - radius); j < min(terrain.height - 1, yy + radius); j++) {
        var d = point_distance(xx, yy, i, j);
        if (d <= radius * terrain.style_radius_coefficient[terrain.style]) {
            script_execute(terrain.submode_equation[terrain.submode], terrain, i, j, dir, avg, d);
        }
    }
}

if (n) {
    vertex_delete_buffer(terrain.terrain_buffer);
    terrain.terrain_buffer = vertex_create_buffer_from_buffer(terrain.terrain_buffer_data, terrain.vertex_format);
}