/// @param UIList

var list = argument0;
var selection = ui_list_selection(list);

if (selection + 1) {
    var type = Stuff.particle.types[| selection];
    ui_input_set_value(list.root.name, type.name);
    ui_input_set_value(list.root.speed_min, string(type.speed_min));
    ui_input_set_value(list.root.speed_max, string(type.speed_max));
    ui_input_set_value(list.root.speed_incr, string(type.speed_incr));
    ui_input_set_value(list.root.speed_wiggle, string(type.speed_wiggle));
    list.root.direction_min.value = normalize_correct(type.direction_min, 0, 1, 0, 360);
    list.root.direction_max.value = normalize_correct(type.direction_max, 0, 1, 0, 360);
    ui_input_set_value(list.root.direction_incr, string(type.direction_incr));
    ui_input_set_value(list.root.direction_wiggle, string(type.direction_wiggle));
    list.root.orientation_min.value = normalize_correct(type.orientation_min, 0, 1, 0, 360);
    list.root.orientation_max.value = normalize_correct(type.orientation_max, 0, 1, 0, 360);
    ui_input_set_value(list.root.orientation_incr, string(type.orientation_incr));
    ui_input_set_value(list.root.orientation_wiggle, string(type.orientation_wiggle));
    list.root.orientation_relative.value = type.orientation_relative;
    ui_input_set_value(list.root.gravity, string(type.gravity));
    list.root.gravity_direction.value = normalize_correct(type.gravity_direction, 0, 1, 0, 360);
    list.root.use_sprite.value = type.sprite_custom;
    ui_list_deselect(list.root.shape);
    ui_list_select(list.root.shape, type.shape, true);
    list.root.base_color_1a.value = type.color_1a;
    list.root.base_color_1a.alpha = type.alpha_1;
    list.root.base_color_1b.value = type.color_1b;
    list.root.base_color_1b_enabled.value = type.color_1b_enabled;
    list.root.base_color_2.value = type.color_2;
    list.root.base_color_2.alpha = type.alpha_2;
    list.root.base_color_2_enabled.value = type.color_2_enabled;
    list.root.base_color_3.value = type.color_3;
    list.root.base_color_3.alpha = type.alpha_3;
    list.root.base_color_3_enabled.value = type.color_3_enabled;
    list.root.additive_blending.value = type.blend;
    ui_input_set_value(list.root.xscale, string(type.xscale));
    ui_input_set_value(list.root.yscale, string(type.yscale));
    ui_input_set_value(list.root.size_min, string(type.size_min));
    ui_input_set_value(list.root.size_max, string(type.size_max));
    ui_input_set_value(list.root.size_incr, string(type.size_incr));
    ui_input_set_value(list.root.size_wiggle, string(type.size_wiggle));
    ui_input_set_value(list.root.life_min, string(type.life_min));
    ui_input_set_value(list.root.life_max, string(type.life_max));
}