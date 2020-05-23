name = "Type";

type = part_type_create();

shape = PartTypeShapes.DISK;

speed_min = 0;
speed_max = 0;
speed_incr = 0;
speed_wiggle = 0;

dir_min = 0;
dir_max = 0;
dir_incr = 0;
dir_wiggle = 0;

gravity = 0;
gravity_direction = 270;

orientation_min = 0;
orientation_max = 0;
orientation_incr = 0;
orientation_wiggle = 0;
orientation_relative = 0;

// random colors
color_a = c_white;
color_b = c_white;
// transitioning colors
color_1 = c_white;
alpha_1 = 1;
color_2 = c_white;
alpha_2 = 1;
color_3 = c_white;
alpha_3 = 1;

blend = false;

size_min = 1;
size_max = 1;
size_incr = 0;
size_wiggle = 0;
xscale = 1;
yscale = 1;

life_min = 2;
life_max = 2;

step_type = noone;
step_count = 10;
death_type = noone;
death_count = 10;

enum PartTypeShapes {
    PIXEL, DISK, SQUARE, LINE, STAR, CIRCLE, RING, SPHERE, FLARE, SPARK, EXPLOSION, CLOUD, SMOKE, SNOW,
}

type_shapes = [pt_shape_pixel, pt_shape_disk, pt_shape_square, pt_shape_line, pt_shape_star, pt_shape_circle, pt_shape_ring, pt_shape_sphere, pt_shape_flare, pt_shape_spark, pt_shape_explosion, pt_shape_cloud, pt_shape_smoke, pt_shape_snow];