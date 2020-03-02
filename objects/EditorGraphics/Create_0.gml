event_inherited();

// this is a very bad workaround and i feel bad about writing it but it
// makes a lot of things easier, like when import_d3d tries to access
// the vertex formats belonging to Stuff.graphics
Stuff.graphics = id;

gpu_set_alphatestenable(true);
gpu_set_alphatestref(20);
gpu_set_tex_repeat(true);

vertex_format_begin();
format_size = 0;
vertex_format_add_position_3d();
format_size = format_size + 12;
vertex_format_add_normal();
format_size = format_size + 12;
vertex_format_add_texcoord();
format_size = format_size + 8;
vertex_format_add_colour();
format_size = format_size + 4;
vertex_format_add_colour();     // second color information is for extra data
format_size = format_size + 4;
vertex_format = vertex_format_end();

vertex_format_begin();
format_size_basic = 0;
vertex_format_add_position_3d();
format_size_basic = format_size_basic + 12;
vertex_format_add_normal();
format_size_basic = format_size_basic + 12;
vertex_format_add_texcoord();
format_size_basic = format_size_basic + 8;
vertex_format_add_colour();
format_size_basic = format_size_basic + 4;
vertex_format_basic = vertex_format_end();

mesh_preview_grid = vertex_create_buffer();
vertex_begin(mesh_preview_grid, vertex_format);

var s2 = 6;
var x1 = -s2 * TILE_WIDTH;
var y1 = -s2 * TILE_HEIGHT;
var x2 = -x1;
var y2 = -y1;

for (var i = 0; i <= 12; i++) {
    vertex_point_line(mesh_preview_grid, x1 + i * TILE_WIDTH, y1, 0, c_white, 1);
    vertex_point_line(mesh_preview_grid, x1 + i * TILE_WIDTH, y2, 0, c_white, 1);
    
    vertex_point_line(mesh_preview_grid, x1, y1 + i * TILE_HEIGHT, 0, c_white, 1);
    vertex_point_line(mesh_preview_grid, x2, y1 + i * TILE_HEIGHT, 0, c_white, 1);
}

vertex_end(mesh_preview_grid);
vertex_freeze(mesh_preview_grid);

c_transform_scaling(Stuff.tile_width, Stuff.tile_height, Stuff.tile_depth);
c_shape_tile = c_shape_create();
c_shape_begin_trimesh();
c_shape_load_trimesh("data\\basic\\ctile.d3d");
c_shape_end_trimesh(c_shape_tile);
c_shape_block = c_shape_create();
c_shape_begin_trimesh();
c_shape_load_trimesh("data\\basic\\cube.d3d");
c_shape_end_trimesh(c_shape_block);
c_transform_identity();
c_shape_sphere = c_shape_create();
c_shape_add_sphere(c_shape_sphere, 1);

var thin_length = 8;
var long_length = 108;
c_shape_axis_x = c_shape_create();
c_shape_axis_y = c_shape_create();
c_shape_axis_z = c_shape_create();
c_shape_axis_x_plane = c_shape_create();
c_shape_axis_y_plane = c_shape_create();
c_shape_axis_z_plane = c_shape_create();
c_shape_add_box(c_shape_axis_x, long_length, thin_length, thin_length);
c_shape_add_box(c_shape_axis_y, thin_length, long_length, thin_length);
c_shape_add_box(c_shape_axis_z, thin_length, thin_length, long_length);
c_shape_add_plane(c_shape_axis_x_plane, 0, 1, 0, 0);
c_shape_add_plane(c_shape_axis_x_plane, 0, 0, 1, 0);
c_shape_add_plane(c_shape_axis_y_plane, 1, 0, 0, 0);
c_shape_add_plane(c_shape_axis_y_plane, 0, 0, 1, 0);
c_shape_add_plane(c_shape_axis_z_plane, 1, 0, 0, 0);
c_shape_add_plane(c_shape_axis_z_plane, 0, 0, 1, 0);

basic_cage = import_d3d("data\\basic\\cage.d3d", false);
indexed_cage = import_d3d("data\\basic\\cage-indexed.d3d", false);
indexed_cage_full = import_d3d("data\\basic\\cage-indexed-full.d3d", false);
basic_cube = import_d3d("data\\basic\\cube.d3d", false);
indexed_cube = import_d3d("data\\basic\\cube-indexed.d3d", false);
base_npc = import_d3d("data\\basic\\base-npc.d3d", false, false);
axes_rotation = import_d3d("data\\basic\\rotation.d3d", false, false);
axes_translation = import_d3d("data\\basic\\translation.d3d", false, false);
axes_translation_x = import_d3d("data\\basic\\translation-x.d3d", false, false);
axes_translation_y = import_d3d("data\\basic\\translation-y.d3d", false, false);
axes_translation_z = import_d3d("data\\basic\\translation-z.d3d", false, false);
axes_translation_x_gold = import_d3d("data\\basic\\translation-x-gold.d3d", false, false);
axes_translation_y_gold = import_d3d("data\\basic\\translation-y-gold.d3d", false, false);
axes_translation_z_gold = import_d3d("data\\basic\\translation-z-gold.d3d", false, false);
var qmark_data = import_d3d("data\\basic\\missing.d3d", false, false, true);
mesh_missing = qmark_data[0];
mesh_missing_data = qmark_data[1];

water_tile_size = 0x1000;
water_reptition = 0x100;
water_units = 200;
water_depth = -24;

mesh_water_base = vertex_create_buffer();
mesh_water_bright = vertex_create_buffer();

vertex_begin(mesh_water_base, vertex_format_basic);
vertex_begin(mesh_water_bright, vertex_format_basic);

for (var i = -water_tile_size / 2; i < water_tile_size / 2; i += (water_tile_size / water_units)) {
    for (var j = -water_tile_size / 2; j < water_tile_size / 2; j += (water_tile_size / water_units)) {
        terrain_create_square(mesh_water_base, i, j, water_tile_size / water_units, 0, 0, water_tile_size / water_reptition / water_units, 0, water_depth, water_depth, water_depth, water_depth);
        terrain_create_square(mesh_water_bright, i, j, water_tile_size / water_units, 0, 0, water_tile_size / water_reptition / water_units, 0, water_depth, water_depth, water_depth, water_depth);
    }
}

vertex_end(mesh_water_base);
vertex_end(mesh_water_bright);
vertex_freeze(mesh_water_base);
vertex_freeze(mesh_water_bright);

grid_sphere = vertex_create_buffer();
vertex_begin(grid_sphere, vertex_format);

var radius = 16;
var segments = 16;

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
        
        vertex_point_line(grid_sphere, point[vec3.xx], point[vec3.yy], point[vec3.zz], c_magenta, 1);
        vertex_point_line(grid_sphere, point2[vec3.xx], point2[vec3.yy], point2[vec3.zz], c_magenta, 1);
        vertex_point_line(grid_sphere, point[vec3.xx], point[vec3.yy], point[vec3.zz], c_magenta, 1);
        vertex_point_line(grid_sphere, point_next[vec3.xx], point_next[vec3.yy], point_next[vec3.zz], c_magenta, 1);
        vertex_point_line(grid_sphere, point2[vec3.xx], point2[vec3.yy], point2[vec3.zz], c_magenta, 1);
        vertex_point_line(grid_sphere, point2_next[vec3.xx], point2_next[vec3.yy], point2_next[vec3.zz], c_magenta, 1);
        vertex_point_line(grid_sphere, point[vec3.xx], point[vec3.yy], point[vec3.zz], c_magenta, 1);
        vertex_point_line(grid_sphere, point2_next[vec3.xx], point2_next[vec3.yy], point2_next[vec3.zz], c_magenta, 1);
        vertex_point_line(grid_sphere, point2[vec3.xx], point2[vec3.yy], point2[vec3.zz], c_magenta, 1);
        vertex_point_line(grid_sphere, point_next[vec3.xx], point_next[vec3.yy], point_next[vec3.zz], c_magenta, 1);
    }
}

vertex_end(grid_sphere);
vertex_freeze(grid_sphere);

axes = vertex_create_buffer();
vertex_begin(axes, vertex_format);

vertex_point_line(axes, 0, 0, 0, c_red, 1);
vertex_point_line(axes, MILLION, 0, 0, c_red, 1);

vertex_point_line(axes, 0, 0, 0, c_green, 1);
vertex_point_line(axes, 0, MILLION, 0, c_green, 1);

vertex_point_line(axes, 0, 0, 0, c_blue, 1);
vertex_point_line(axes, 0, 0, MILLION, c_blue, 1);
    
vertex_end(axes);
vertex_freeze(axes);

axes_centered = vertex_create_buffer();
vertex_begin(axes_centered, vertex_format);

vertex_point_line(axes_centered, -MILLION, 0, 0, c_red, 1);
vertex_point_line(axes_centered, MILLION, 0, 0, c_red, 1);

vertex_point_line(axes_centered, 0, -MILLION, 0, c_green, 1);
vertex_point_line(axes_centered, 0, MILLION, 0, c_green, 1);

vertex_point_line(axes_centered, 0, 0, -MILLION, c_blue, 1);
vertex_point_line(axes_centered, 0, 0, MILLION, c_blue, 1);
    
vertex_end(axes_centered);
vertex_freeze(axes_centered);

grid = noone;
grid_centered = noone;