/// @param UIButton

var button = argument0;

var fn = get_save_filename_gml("particles.gml");
if (fn == "") {
    return;
}

var emitter_shape_names = ["ps_shape_rectangle", "ps_shape_ellipse", "ps_shape_diamond", "ps_shape_line"];
var emitter_distribution_names = ["ps_distr_linear", "ps_distr_gaussian", "ps_distr_invgaussian"];
var type_shape_names = ["pt_shape_pixel", "pt_shape_disk", "pt_shape_square", "pt_shape_line", "pt_shape_star", "pt_shape_circle", "pt_shape_ring", "pt_shape_sphere", "pt_shape_flare", "pt_shape_spark", "pt_shape_explosion", "pt_shape_cloud", "pt_shape_smoke", "pt_shape_snow"];

var sys_name = "global._part_system";
var text = sys_name + " = part_system_create();\n\n";
text += "var _fps = game_get_speed(gamespeed_fps);\n\n";

// part types
for (var i = 0; i < ds_list_size(Stuff.particle.types); i++) {
    var type = Stuff.particle.types[| i];
    var type_name = "type_" + string(i);
    text += "/* " + type.name + " */\n";
    text += "" + type_name + " = part_type_create();\n";
    text += "part_type_shape(" + type_name + ", " + type_shape_names[type.shape] + ");\n";
    text += "part_type_speed(" + type_name + ", " + string(type.speed_min) + ", " + string(type.speed_max) +
        ", " + string(type.speed_incr) + ", " + string(type.speed_wiggle) + ");\n";
    text += "part_type_direction(" + type_name + ", " + string(type.direction_min) + ", " +
        string(type.direction_max) + ", " + string(type.direction_incr) + ", " + string(type.direction_wiggle) + ");\n";
    text += "part_type_gravity(" + type_name + ", " + string(type.gravity) + ", " + string(type.gravity_direction) + ");\n";
    text += "part_type_orientation(" + type_name + ", " + string(type.orientation_min) + ", " + string(type.orientation_max) +
        ", " + string(type.orientation_incr) + ", " + string(type.orientation_wiggle) + ", " + string(type.orientation_relative) + ");\n";
    text += "part_type_size(" + type_name + ", " + string(type.size_min) + ", " + string(type.size_max) + ", " +
        string(type.size_incr) + ", " + string(type.size_wiggle) + ");\n";
    text += "part_type_scale(" + type_name + ", " + string(type.xscale) + ", " + string(type.yscale) + ");\n";
    text += "part_type_life(" + type_name + ", " + string(type.life_min) + " * _fps, " + string(type.life_max) + " * _fps);\n";
}

text += "\n";

var secondary = false;
// secondary emission - particles must be previously defined
for (var i = 0; i < ds_list_size(Stuff.particle.types); i++) {
    var type = Stuff.particle.types[| i];
    var type_name = "type_" + string(i);
    if (type.update_type) {
        var update_name = "type_" + string(ds_list_find_index(Stuff.particle.types, type.update_type));
        text += "part_type_step(" + type_name + ", ceil(" + string(type.update_rate) + "/ _fps), " + update_name + ");\n";
        secondary = true;
    }
    if (type.death_type) {
        var death_name = "type_" + string(ds_list_find_index(Stuff.particle.types, type.death_type));
        text += "part_type_death(" + type_name + ", " + string(type.death_rate) + ", " + death_name + ");\n";
        secondary = true;
    }
}

// if no secondary emissions have been defined you just get an ugly second line break
if (secondary) {
    text += "\n";
}

// emitters
for (var i = 0; i < ds_list_size(Stuff.particle.emitters); i++) {
    var emitter = Stuff.particle.emitters[| i];
    var em_name = "emitter_" + string(i);
    text += "/* " + emitter.name + " */\n";
    text += em_name + " = part_emitter_create(" + sys_name + ");\n";
    text += "part_emitter_region(" + sys_name + ", " + em_name + ", " + string(emitter.region_x1) + ", " +
        string(emitter.region_x2) + ", " + string(emitter.region_y1) + ", " + string(emitter.region_y2) + ", " +
        emitter_shape_names[emitter.region_shape] + ", " + emitter_distribution_names[emitter.region_distribution] + ");\n";
    if (emitter.type) {
        var type_index = ds_list_find_index(Stuff.particle.types, emitter.type);
        text += ((!emitter.streaming) ? "// " : "") + "part_emitter_stream(" + sys_name + ", " + em_name + ", " +
            "type_" + string(type_index) + ", " + string(emitter.rate) + " / _fps);\n";
    }
}

var fbuffer = buffer_create(1024, buffer_grow, 1);
buffer_write(fbuffer, buffer_text, text);
buffer_save(fbuffer, fn);
buffer_delete(fbuffer);