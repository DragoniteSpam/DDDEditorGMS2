function editor_particle_generate_code() {
    var emitter_shape_names = ["ps_shape_rectangle", "ps_shape_ellipse", "ps_shape_diamond", "ps_shape_line"];
    var emitter_distribution_names = ["ps_distr_linear", "ps_distr_gaussian", "ps_distr_invgaussian"];
    var type_shape_names = ["pt_shape_pixel", "pt_shape_disk", "pt_shape_square", "pt_shape_line", "pt_shape_star", "pt_shape_circle", "pt_shape_ring", "pt_shape_sphere", "pt_shape_flare", "pt_shape_spark", "pt_shape_explosion", "pt_shape_cloud", "pt_shape_smoke", "pt_shape_snow"];

    var sys_name = "global._part_system";
    var text = sys_name + " = part_system_create();\n\n";
    text += "part_system_automatic_update(" + sys_name + ", " + (string(Stuff.particle.system_auto_update) ? "true" : "false") + ");\n";
    text += "part_system_automatic_draw(" + sys_name + ", true);\n";
    text += "var _fps = game_get_speed(gamespeed_fps);\n\n";

    // part types
    for (var i = 0; i < ds_list_size(Stuff.particle.types); i++) {
        var type = Stuff.particle.types[| i];
        var type_name = "global._part_type_" + string(i);
        text += "/* " + type.name + " */\n";
        text += "" + type_name + " = part_type_create();\n";
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
        text += "part_type_blend(" + type_name + ", " + (type.blend ? "true" : "false") + ");\n";
    
        if (type.color_1b_enabled) {
            text += "part_type_color_mix(" + type_name + ", " + string(type.color_1a) + ", " + string(type.color_1b) + ");\n";
            text += "part_type_alpha1(" + type_name + ", " + string(type.alpha_1) + ");\n";
        } else {
            if (type.color_3_enabled) {
                text += "part_type_color3(" + type_name + ", " + string(type.color_1a) + ", " + string(type.color_2) + ", " + string(type.color_3) + ");\n";
                text += "part_type_alpha3(" + type_name + ", " + string(type.alpha_1) + ", " + string(type.alpha_2) + ", " + string(type.alpha_3) + ");\n";
            } else if (type.color_2_enabled) {
                text += "part_type_color2(" + type_name + ", " + string(type.color_1a) + ", " + string(type.color_2) + ");\n";
                text += "part_type_alpha2(" + type_name + ", " + string(type.alpha_1) + ", " + string(type.alpha_2) + ");\n";
            } else {
                text += "part_type_color1(" + type_name + ", " + string(type.color_1a) + ");\n";
                text += "part_type_alpha1(" + type_name + ", " + string(type.alpha_1) + ");\n";
            }
        }
    
        var sprite = guid_get(type.sprite);
        if (type.sprite_custom && sprite) {
            text += "part_type_sprite(" + type_name + ", " + sprite.internal_name + ", " + (type.sprite_animated ? "true" : "false") +
                ", " + (type.sprite_stretched ? "true" : "false") + ", " + (type.sprite_random ? "true" : "false") + ");\n";
        } else {
            text += "part_type_shape(" + type_name + ", " + type_shape_names[type.shape] + ");\n";
        }
    }

    text += "\n";

    var secondary = false;
    // secondary emission - particles must be previously defined
    for (var i = 0; i < ds_list_size(Stuff.particle.types); i++) {
        var type = Stuff.particle.types[| i];
        var type_name = "global._part_type_" + string(i);
        if (type.update_type) {
            var update_name = "global._part_type_" + string(ds_list_find_index(Stuff.particle.types, type.update_type));
            text += "part_type_step(" + type_name + ", ceil(" + string(type.update_rate) + "/ _fps), " + update_name + ");\n";
            secondary = true;
        }
        if (type.death_type) {
            var death_name = "global._part_type_" + string(ds_list_find_index(Stuff.particle.types, type.death_type));
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
        var em_name = "global._part_emitter_" + string(i);
        text += "/* " + emitter.name + " */\n";
        text += em_name + " = part_emitter_create(" + sys_name + ");\n";
        text += "part_emitter_region(" + sys_name + ", " + em_name + ", " + string(emitter.region_x1) + ", " +
            string(emitter.region_x2) + ", " + string(emitter.region_y1) + ", " + string(emitter.region_y2) + ", " +
            emitter_shape_names[emitter.region_shape] + ", " + emitter_distribution_names[emitter.region_distribution] + ");\n";
        if (emitter.type) {
            text += "var _odds = " + string(emitter.rate) + ";\n";
            text += "if (_odds < _fps) {\n    var _rate =  -1 / (_odds / _fps);\n} else {\n    var _rate = _odds / _fps;\n}\n";
            var type_name = "global._part_type_" + string(ds_list_find_index(Stuff.particle.types, emitter.type));
            text += ((!emitter.streaming) ? "// " : "") + "part_emitter_stream(" + sys_name + ", " + em_name + ", " +
                string(type_name) + ", _rate);\n";
        }
    }

    return text;


}
