/// @param buffer
function serialize_save_particles(argument0) {

	var buffer = argument0;
	var mode = Stuff.particle;

	var version = 0;
	buffer_write(buffer, buffer_u32, version);

	var addr_end = buffer_tell(buffer);
	buffer_write(buffer, buffer_u64, 0);

#region emitters
	var n_emitters = ds_list_size(mode.emitters);
	buffer_write(buffer, buffer_u8, n_emitters);

	for (var i = 0; i < n_emitters; i++) {
	    var emitter = mode.emitters[| i];
	    var bools = pack(
	        emitter.streaming,
	        emitter.draw_region
	    );
	    buffer_write(buffer, buffer_string, emitter.name);
	    buffer_write(buffer, buffer_u8, emitter.region_shape);
	    buffer_write(buffer, buffer_u8, emitter.region_distribution);
	    buffer_write(buffer, buffer_f32, emitter.region_x1);
	    buffer_write(buffer, buffer_f32, emitter.region_x2);
	    buffer_write(buffer, buffer_f32, emitter.region_y1);
	    buffer_write(buffer, buffer_f32, emitter.region_y2);
	    buffer_write(buffer, buffer_f32, emitter.rate);
	    buffer_write(buffer, buffer_s16, ds_list_find_index(mode.types, emitter.type));
	    buffer_write(buffer, buffer_u32, bools);
	}
#endregion

#region types
	var n_types = ds_list_size(mode.types);
	buffer_write(buffer, buffer_u8, n_types);

	for (var i = 0; i < n_types; i++) {
	    var type = mode.types[| i];
	    var bools = pack(
	        type.sprite_custom,
	        type.sprite_animated,
	        type.sprite_stretched,
	        type.sprite_random,
	        // ---------
	        type.color_1b_enabled,
	        type.color_2_enabled,
	        type.color_3_enabled,
	        type.blend,
	        // ---------
	        type.orientation_relative,
	    );
	    buffer_write(buffer, buffer_string, type.name);
	    buffer_write(buffer, buffer_u8, type.shape);
	    buffer_write(buffer, buffer_datatype, type.sprite);
	    buffer_write(buffer, buffer_string, guid_get(type.sprite) ? guid_get(type.sprite).internal_name : "");
	    buffer_write(buffer, buffer_f32, type.speed_min);
	    buffer_write(buffer, buffer_f32, type.speed_max);
	    buffer_write(buffer, buffer_f32, type.speed_incr);
	    buffer_write(buffer, buffer_f32, type.speed_wiggle);
	    buffer_write(buffer, buffer_f32, type.direction_min);
	    buffer_write(buffer, buffer_f32, type.direction_max);
	    buffer_write(buffer, buffer_f32, type.direction_incr);
	    buffer_write(buffer, buffer_f32, type.direction_wiggle);
	    buffer_write(buffer, buffer_f32, type.gravity);
	    buffer_write(buffer, buffer_f32, type.gravity_direction);
	    buffer_write(buffer, buffer_f32, type.orientation_min);
	    buffer_write(buffer, buffer_f32, type.orientation_max);
	    buffer_write(buffer, buffer_f32, type.orientation_incr);
	    buffer_write(buffer, buffer_f32, type.orientation_wiggle);
	    buffer_write(buffer, buffer_u32, type.color_1a);
	    buffer_write(buffer, buffer_f32, type.alpha_1);
	    buffer_write(buffer, buffer_u32, type.color_1b);
	    buffer_write(buffer, buffer_u32, type.color_2);
	    buffer_write(buffer, buffer_f32, type.alpha_2);
	    buffer_write(buffer, buffer_u32, type.color_3);
	    buffer_write(buffer, buffer_f32, type.alpha_3);
	    buffer_write(buffer, buffer_f32, type.size_min);
	    buffer_write(buffer, buffer_f32, type.size_max);
	    buffer_write(buffer, buffer_f32, type.size_incr);
	    buffer_write(buffer, buffer_f32, type.size_wiggle);
	    buffer_write(buffer, buffer_f32, type.xscale);
	    buffer_write(buffer, buffer_f32, type.yscale);
	    buffer_write(buffer, buffer_f32, type.life_min);
	    buffer_write(buffer, buffer_f32, type.life_max);
	    buffer_write(buffer, buffer_s16, ds_list_find_index(mode.types, type.update_type));
	    buffer_write(buffer, buffer_f32, type.update_rate);
	    buffer_write(buffer, buffer_s16, ds_list_find_index(mode.types, type.death_type));
	    buffer_write(buffer, buffer_f32, type.death_rate);
	    buffer_write(buffer, buffer_u32, bools);
	}
#endregion

	buffer_poke(buffer, addr_end, buffer_u64, buffer_tell(buffer));


}
