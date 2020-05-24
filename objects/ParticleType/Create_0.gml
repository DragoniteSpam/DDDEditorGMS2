name = "Type";

type = part_type_create();

shape = PartTypeShapes.SPHERE;
part_type_shape(type, pt_shape_sphere);

speed_min = 0;
speed_max = 0;
speed_incr = 0;
speed_wiggle = 0;
part_type_speed(type, speed_min, speed_max, speed_incr, speed_wiggle);

direction_min = 0;
direction_max = 0;
direction_incr = 0;
direction_wiggle = 0;
part_type_direction(type, direction_min, direction_max, direction_incr, direction_wiggle);

gravity = 0.25;
gravity_direction = 270;
part_type_gravity(type, gravity, gravity_direction);

orientation_min = 0;
orientation_max = 0;
orientation_incr = 0;
orientation_wiggle = 0;
orientation_relative = 0;
part_type_orientation(type, orientation_min, orientation_max, orientation_incr, orientation_wiggle, orientation_relative);

color_1a = c_white;
alpha_1 = 1;
color_1b = c_white;
color_1b_enabled = false;
color_2 = c_white;
alpha_2 = 1;
color_2_enabled = false;
color_3 = c_white;
alpha_3 = 1;
color_3_enabled = false;

blend = false;

size_min = 1;
size_max = 1;
size_incr = 0;
size_wiggle = 0;
part_type_size(type, size_min, size_max, size_incr, size_wiggle);
xscale = 1;
yscale = 1;
part_type_scale(type, xscale, yscale);

life_min = 2;
life_max = 2;
var f = game_get_speed(gamespeed_fps);
part_type_life(type, life_min * f, life_max * f);

update_type = noone;
update_rate = 10;
death_type = noone;
death_rate = 10;

enum PartTypeShapes {
    PIXEL, DISK, SQUARE, LINE, STAR, CIRCLE, RING, SPHERE, FLARE, SPARK, EXPLOSION, CLOUD, SMOKE, SNOW,
}

type_shapes = [pt_shape_pixel, pt_shape_disk, pt_shape_square, pt_shape_line, pt_shape_star, pt_shape_circle, pt_shape_ring, pt_shape_sphere, pt_shape_flare, pt_shape_spark, pt_shape_explosion, pt_shape_cloud, pt_shape_smoke, pt_shape_snow];