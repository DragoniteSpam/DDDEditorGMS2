/// @param UIButton

var button = argument0;

var emitter_shape_names = ["ps_shape_rectangle", "ps_shape_ellipse", "ps_shape_diamond", "ps_shape_line"];
var emitter_distribution_names = ["ps_distr_linear", "ps_distr_gaussian", "ps_distr_invgaussian"];
var type_shape_names = ["pt_shape_pixel", "pt_shape_disk", "pt_shape_square", "pt_shape_line", "pt_shape_star", "pt_shape_circle", "pt_shape_ring", "pt_shape_sphere", "pt_shape_flare", "pt_shape_spark", "pt_shape_explosion", "pt_shape_cloud", "pt_shape_smoke", "pt_shape_snow"];

var text = "system = part_system_create();\n\n";
text += "var _fps = game_get_speed(gamespeed_fps);\n\n";

for (var i = 0; i < ds_list_size(Stuff.particle.types); i++) {
    var type = Stuff.particle.types[| i];
    text += "/* " + type.name + " */\n";
    text += "type_" + string(i) + " = part_type_create();\n";
    text += "part_type_shape(type_" + string(i) + ", " + type_shape_names[type.shape] + ");\n";
    text += "part_type_speed(type_" + string(i) + ", " + string(type.speed_min) + ", " + string(type.speed_max) +
        ", " + string(type.speed_incr) + ", " + string(type.speed_wiggle) + ");\n";
    text += "part_type_direction(type_" + string(i) + ", " + string(type.direction_min) + ", " +
        string(type.direction_max) + ", " + string(type.direction_incr) + ", " + string(type.direction_wiggle) + ");\n";
    text += "part_type_gravity(type_" + string(i) + ", " + string(type.gravity) + ", " + string(type.gravity_direction) + ");\n";
    text += "part_type_orientation(type_" + string(i) + ", " + string(type.orientation_min) + ", " + string(type.orientation_max) +
        ", " + string(type.orientation_incr) + ", " + string(type.orientation_wiggle) + ", " + string(type.orientation_relative) + ");\n";
    text += "part_type_size(type_" + string(i) + ", " + string(type.size_min) + ", " + string(type.size_max) + ", " +
        string(type.size_incr) + ", " + string(type.size_wiggle) + ");\n";
    text += "part_type_scale(type_" + string(i) + ", " + string(type.xscale) + ", " + string(type.yscale) + ");\n";
    text += "part_type_life(type_" + string(i) + ", " + string(type.life_min) + " * _fps, " + string(type.life_max) + " * _fps);\n";
    if (type.update_type) {
        text += "part_type_step(type_" + string(i) + ", " + string(type.update_rate) + "/ _fps, " + string(type.update_type.type) + ");\n";
    }
    if (type.death_type) {
        text += "part_type_death(type_" + string(i) + ", " + string(type.death_rate) + ", " + string(type.death_type)+");\n";
    }
    text += "\n";
}

text += "\n";

for (var i = 0; i < ds_list_size(Stuff.particle.emitters); i++) {
    var emitter = Stuff.particle.emitters[| i];
    text += "/* " + emitter.name + " */\n";
    text += "emitter_" + string(i) + " = part_emitter_create(system);\n";
    text += "part_emitter_region(system, emitter_" + string(i) + ", " + string(emitter.region_x1) + ", " +
        string(emitter.region_x2) + ", " + string(emitter.region_y1) + ", " + string(emitter.region_y2) + ", " +
        emitter_shape_names[emitter.region_shape] + ", " + emitter_distribution_names[emitter.region_distribution] + ");\n";
    if (emitter.type) {
        var type_index = ds_list_find_index(Stuff.particle.types, emitter.type);
        text += ((!emitter.streaming) ? "// " : "") + "part_emitter_stream(system, emitter_" + string(i) + ", " +
            "type_" + string(type_index) + ", " + string(emitter.rate) + " / _fps);\n";
    }
    text += "\n";
}

text += "\n\n";