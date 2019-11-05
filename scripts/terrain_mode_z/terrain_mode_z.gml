/// @param EditorModeTerrain
/// @param cursor-position[]
/// @param direction

var terrain = argument0;
var position = argument1;
var dir = argument2;
var xx = position[vec3.xx];
var yy = position[vec3.yy];
var radius = terrain.radius;

var t = 0;
var coeff = radius * terrain.style_radius_coefficient[terrain.style];

var list_range = ds_list_create();

for (var i = max(0, xx - radius + 1); i < min(terrain.width, xx + radius + 1); i++) {
    for (var j = max(0, yy - radius + 1); j < min(terrain.height, yy + radius + 1); j++) {
        var d1 = point_distance(xx + 0.5, yy + 0.5, i + 0.5, j + 0.5);
        var d2 = point_distance(xx + 0.5, yy + 0.5, i + 1.5, j + 0.5);
        var d3 = point_distance(xx + 0.5, yy + 0.5, i + 0.5, j + 1.5);
        var d4 = point_distance(xx + 0.5, yy + 0.5, i + 1.5, j + 1.5);
        if (d1 <= coeff && d2 <= coeff && d3 <= coeff && d4 <= coeff) {
            t = t + terrain_get_z(terrain, floor(i), floor(j));
            ds_list_add(list_range, vector3(floor(i), floor(j), mean(d1, d2, d3, d4)));
        }
    }
}

var avg = t / ds_list_size(list_range);

for (var i = 0; i < ds_list_size(list_range); i++) {
	var coordinates = list_range[| i];
	script_execute(terrain.submode_equation[terrain.submode], terrain, coordinates[vec3.xx], coordinates[vec3.yy], dir, avg, coordinates[vec3.zz]);
}

for (var i = 0; i < ds_list_size(list_range); i++) {
	var coordinates = list_range[| i];
	terrain_set_normals(terrain, coordinates[vec3.xx], coordinates[vec3.yy]);
}

if (!ds_list_empty(list_range)) {
    terrain_refresh_vertex_buffer(terrain);
}

ds_list_destroy(list_range);