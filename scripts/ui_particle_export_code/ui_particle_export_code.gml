/// @param UIButton

var button = argument0;

var emitter_shape_names = ["ps_shape_rectangle", "ps_shape_ellipse", "ps_shape_diamond", "ps_shape_line"];
var emitter_distribution_names = ["ps_distr_linear", "ps_distr_gaussian", "ps_distr_invgaussian"];

var text = "system = part_system_create()\n\n";
text += "var _fps = game_get_speed(gamespeed_fps);\n\n";

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
}