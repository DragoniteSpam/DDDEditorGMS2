/// @param buffer
/// @param version
function serialize_load_particles(buffer, version) {
    var mode = Stuff.particle;
    editor_particle_reset();
    buffer_read(buffer, buffer_u32);
    var addr_end = buffer_read(buffer, buffer_u64);
    
    #region emitters
    var n_emitters = buffer_read(buffer, buffer_u8);
    repeat (n_emitters) {
        var emitter = instance_create_depth(0, 0, 0, ParticleEmitter);
        instance_deactivate_object(emitter);
        ds_list_add(mode.emitters, emitter);
        
        emitter.name = buffer_read(buffer, buffer_string);
        emitter.region_shape = buffer_read(buffer, buffer_u8);
        emitter.region_distribution = buffer_read(buffer, buffer_u8);
        emitter.region_x1 = buffer_read(buffer, buffer_f32);
        emitter.region_x2 = buffer_read(buffer, buffer_f32);
        emitter.region_y1 = buffer_read(buffer, buffer_f32);
        emitter.region_y2 = buffer_read(buffer, buffer_f32);
        emitter.rate = buffer_read(buffer, buffer_f32);
        emitter.type = buffer_read(buffer, buffer_s16);
        
        var bools = buffer_read(buffer, buffer_u32);
        emitter.streaming =         unpack(bools, 0);
        emitter.draw_region =       unpack(bools, 1);
    }
    #endregion
    
    #region types
    var n_types = buffer_read(buffer, buffer_u8);
    repeat (n_types) {
        var type = instance_create_depth(0, 0, 0, ParticleType);
        instance_deactivate_object(type);
        ds_list_add(mode.types, type);
        
        type.name = buffer_read(buffer, buffer_string);
        type.shape = buffer_read(buffer, buffer_u8);
        // if a particle sprite with the saved internal name exists, use that;
        // otherwise try to link the GUID
        type.sprite = buffer_read(buffer, buffer_datatype);
        var spr_name = buffer_read(buffer, buffer_string);
        if (internal_name_get(spr_name)) {
            type.sprite = internal_name_get(spr_name).GUID;
        }
        
        type.speed_min = buffer_read(buffer, buffer_f32);
        type.speed_max = buffer_read(buffer, buffer_f32);
        type.speed_incr = buffer_read(buffer, buffer_f32);
        type.speed_wiggle = buffer_read(buffer, buffer_f32);
        type.direction_min = buffer_read(buffer, buffer_f32);
        type.direction_max = buffer_read(buffer, buffer_f32);
        type.direction_incr = buffer_read(buffer, buffer_f32);
        type.direction_wiggle = buffer_read(buffer, buffer_f32);
        type.gravity = buffer_read(buffer, buffer_f32);
        type.gravity_direction = buffer_read(buffer, buffer_f32);
        type.orientation_min = buffer_read(buffer, buffer_f32);
        type.orientation_max = buffer_read(buffer, buffer_f32);
        type.orientation_incr = buffer_read(buffer, buffer_f32);
        type.orientation_wiggle = buffer_read(buffer, buffer_f32);
        type.color_1a = buffer_read(buffer, buffer_u32);
        type.alpha_1 = buffer_read(buffer, buffer_f32);
        type.color_1b = buffer_read(buffer, buffer_u32);
        type.color_2 = buffer_read(buffer, buffer_u32);
        type.alpha_2 = buffer_read(buffer, buffer_f32);
        type.color_3 = buffer_read(buffer, buffer_u32);
        type.alpha_3 = buffer_read(buffer, buffer_f32);
        type.size_min = buffer_read(buffer, buffer_f32);
        type.size_max = buffer_read(buffer, buffer_f32);
        type.size_incr = buffer_read(buffer, buffer_f32);
        type.size_wiggle = buffer_read(buffer, buffer_f32);
        type.xscale = buffer_read(buffer, buffer_f32);
        type.yscale = buffer_read(buffer, buffer_f32);
        type.life_min = buffer_read(buffer, buffer_f32);
        type.life_max = buffer_read(buffer, buffer_f32);
        type.update_type = buffer_read(buffer, buffer_s16);
        type.update_rate = buffer_read(buffer, buffer_f32);
        type.death_type = buffer_read(buffer, buffer_s16);
        type.death_rate = buffer_read(buffer, buffer_f32);
        
        var bools = buffer_read(buffer, buffer_u32);
        type.sprite_custom =        unpack(bools, 0);
        type.sprite_animated =      unpack(bools, 1);
        type.sprite_stretched =     unpack(bools, 2);
        type.sprite_random =        unpack(bools, 3);
        type.color_1b_enabled =     unpack(bools, 4);
        type.color_2_enabled =      unpack(bools, 5);
        type.color_3_enabled =      unpack(bools, 6);
        type.blend =                unpack(bools, 7);
        type.orientation_relative = unpack(bools, 8);
    }
    #endregion
    
    #region linkage
    for (var i = 0; i < n_emitters; i++) {
        var emitter = mode.emitters[| i];
        emitter.type = mode.types[| emitter.type] ? mode.types[| emitter.type] : noone;
        editor_particle_emitter_set_emission(emitter);
        editor_particle_emitter_set_region(emitter);
        editor_particle_emitter_create_region(emitter);
    }
    for (var i = 0; i < n_types; i++) {
        var type = mode.types[| i];
        type.update_type = mode.types[| type.update_type] ? mode.types[| type.update_type] : noone;
        type.death_type = mode.types[| type.death_type] ? mode.types[| type.death_type] : noone;
        
        part_type_speed(type.type, type.speed_min, type.speed_max, type.speed_incr, type.speed_wiggle);
        part_type_direction(type.type, type.direction_min, type.direction_max, type.direction_incr, type.direction_wiggle);
        part_type_orientation(type.type, type.orientation_min, type.orientation_max, type.orientation_incr, type.orientation_wiggle, type.orientation_relative);
        part_type_gravity(type.type, type.gravity, type.gravity_direction);
        editor_particle_type_set_sprite(type);
        editor_particle_type_set_color(type);
        part_type_blend(type.type, type.blend);
        part_type_scale(type.type, type.xscale, type.yscale);
        part_type_size(type.type, type.size_min, type.size_max, type.size_incr, type.size_wiggle);
        var f = game_get_speed(gamespeed_fps);
        part_type_life(type.type, type.life_min * f, type.life_max * f);
        var odds = editor_particle_rate_odds(type.update_rate);
        if (type.update_type) part_type_step(type.type, odds, type.update_type.type);
        if (type.death_type) part_type_death(type.type, type.death_rate, type.death_type.type);
    }
    #endregion
}