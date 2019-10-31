/// @param EditorModeTerrain
/// @param cursor-position[]
/// @param direction

var terrain = argument0;
var position = argument1;
var dir = argument2;
var xx = floor(position[vec3.xx]);
var yy = floor(position[vec3.yy]);
var radius = floor(terrain.radius);

var t = 0;

var list_range = ds_list_create();

for (var i = max(0, xx - radius + 1); i < min(terrain.width - 1, xx + radius + 1); i++) {
    for (var j = max(0, yy - radius + 1); j < min(terrain.height - 1, yy + radius + 1); j++) {
        var d = point_distance(xx, yy, i + 0.5, j + 0.5);
        if (d <= radius * terrain.style_radius_coefficient[terrain.style]) {
            t = t + terrain_get_z(terrain, i, j);
            ds_list_add(list_range, vector2(i, j));
        }
    }
}

var avg = t / ds_list_size(list_range);

for (var i = 0; i < ds_list_size(list_range); i++) {
	var coordinates = list_range[| i];
	script_execute(terrain.submode_equation[terrain.submode], terrain, coordinates[vec2.xx], coordinates[vec2.yy], dir, avg, d);
}

for (var i = 0; i < ds_list_size(list_range); i++) {
	var coordinates = list_range[| i];
	terrain_set_normals(terrain, coordinates[vec2.xx], coordinates[vec2.yy], xx, yy, radius);
}

if (!ds_list_empty(list_range)) {
    vertex_delete_buffer(terrain.terrain_buffer);
    terrain.terrain_buffer = vertex_create_buffer_from_buffer(terrain.terrain_buffer_data, terrain.vertex_format);
	vertex_freeze(terrain.terrain_buffer);
}

ds_list_destroy(list_range);