/// @param UIList
function ui_particle_type_select(argument0) {

	var list = argument0;
	var selection = ui_list_selection(list);

	if (selection + 1) {
	    var type = Stuff.particle.types[| selection];
	    ui_input_set_value(list.root.name, type.name);
	    ui_input_set_value(list.root.speed_min, string_format(type.speed_min, 1, 3));
	    ui_input_set_value(list.root.speed_max, string_format(type.speed_max, 1, 3));
	    ui_input_set_value(list.root.speed_incr, string_format(type.speed_incr, 1, 3));
	    ui_input_set_value(list.root.speed_wiggle, string_format(type.speed_wiggle, 1, 3));
	    list.root.direction_min.value = normalize_correct(type.direction_min, 0, 1, 0, 1, 360);
	    list.root.direction_max.value = normalize_correct(type.direction_max, 0, 1, 0, 1, 360);
	    ui_input_set_value(list.root.direction_incr, string_format(type.direction_incr, 1, 3));
	    ui_input_set_value(list.root.direction_wiggle, string_format(type.direction_wiggle, 1, 3));
	    list.root.orientation_min.value = normalize_correct(type.orientation_min, 0, 1, 0, 1, 360);
	    list.root.orientation_max.value = normalize_correct(type.orientation_max, 0, 1, 0, 1, 360);
	    ui_input_set_value(list.root.orientation_incr, string_format(type.orientation_incr, 1, 3));
	    ui_input_set_value(list.root.orientation_wiggle, string_format(type.orientation_wiggle, 1, 3));
	    list.root.orientation_relative.value = type.orientation_relative;
	    ui_input_set_value(list.root.gravity, string_format(type.gravity, 1, 3));
	    list.root.gravity_direction.value = normalize_correct(type.gravity_direction, 0, 1, 0, 1, 360);
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
	    ui_input_set_value(list.root.xscale, string_format(type.xscale, 1, 3));
	    ui_input_set_value(list.root.yscale, string_format(type.yscale, 1, 3));
	    ui_input_set_value(list.root.size_min, string_format(type.size_min, 1, 3));
	    ui_input_set_value(list.root.size_max, string_format(type.size_max, 1, 3));
	    ui_input_set_value(list.root.size_incr, string_format(type.size_incr, 1, 3));
	    ui_input_set_value(list.root.size_wiggle, string_format(type.size_wiggle, 1, 3));
	    ui_input_set_value(list.root.life_min, string_format(type.life_min, 1, 3));
	    ui_input_set_value(list.root.life_max, string_format(type.life_max, 1, 3));
	}


}
