/// @param buffer
/// @param Entity
/// @param version

argument1.name = buffer_read(argument0, buffer_string);
argument1.xx = buffer_read(argument0, buffer_u32);
argument1.yy = buffer_read(argument0, buffer_u32);
argument1.zz = buffer_read(argument0, buffer_u32);
refid_set(argument1, buffer_read(argument0, buffer_u32));

var state_solid = argument1.am_solid;
var state_static = argument1.static;

var entity_bools = buffer_read(argument0, buffer_u32);
argument1.am_solid = unpack(entity_bools, 0);
argument1.static = unpack(entity_bools, 1);
argument1.animate_idle = unpack(entity_bools, 2);
argument1.animate_movement = unpack(entity_bools, 3);
argument1.direction_fix = unpack(entity_bools, 4);

// meshes and pawns are solid by default, so if the state of their
// solidness changes, this needs to be reflected in the map stats
// counter
if (state_solid && !argument1.am_solid) {
    ActiveMap.population_solid--;
} else if (!state_solid && argument1.am_solid) {
    ActiveMap.population_solid++;
}

// same for statics
if (state_static && !argument1.static) {
    ActiveMap.population_static--;
} else if (!state_static && argument1.static) {
    ActiveMap.population_static++;
}

var n_events = buffer_read(argument0, buffer_u8);
repeat(n_events) {
    serialize_load_entity_event_page(argument0, argument1, argument2);
}

argument1.off_xx = buffer_read(argument0, buffer_f32);
argument1.off_yy = buffer_read(argument0, buffer_f32);
argument1.off_zz = buffer_read(argument0, buffer_f32);
    
argument1.rot_xx = buffer_read(argument0, buffer_u16);
argument1.rot_yy = buffer_read(argument0, buffer_u16);
argument1.rot_zz = buffer_read(argument0, buffer_u16);
    
argument1.scale_xx = buffer_read(argument0, buffer_f32);
argument1.scale_yy = buffer_read(argument0, buffer_f32);
argument1.scale_zz = buffer_read(argument0, buffer_f32);

argument1.autonomous_movement = buffer_read(argument0, buffer_u8);
argument1.autonomous_movement_speed = buffer_read(argument0, buffer_u8);
argument1.autonomous_movement_frequency = buffer_read(argument0, buffer_u8);
argument1.autonomous_movement_route = buffer_read(argument0, buffer_u32);
    
var n_move_routes = buffer_read(argument0, buffer_u8);
repeat(n_move_routes) {
    serialize_load_move_route(argument0, argument1, argument2);
}

if (argument2 >= DataVersions.GAME_VARIABLES) {
    ds_list_clear(argument1.switches);
    ds_list_clear(argument1.variables);
    
    var n_variables = buffer_read(argument0, buffer_u8);
    repeat (n_variables) {
        if (argument1 < DataVersions.STRIPPED_SELF_VARIABLES) {
            buffer_read(argument0, buffer_string);
        }
        ds_list_add(argument1.switches, buffer_read(argument0, buffer_bool));
        
        if (argument1 < DataVersions.STRIPPED_SELF_VARIABLES) {
            buffer_read(argument0, buffer_string);
        }
        ds_list_add(argument1.variables, buffer_read(argument0, buffer_f32));
    }
    
    while (ds_list_size(argument1.switches) < BASE_SELF_VARIABLES) {
        ds_list_add(argument1.switches, false);
    }
    while (ds_list_size(argument1.variables) < BASE_SELF_VARIABLES) {
        ds_list_add(argument1.variables, 0);
    }
}

// this should not be instantiated on its own and does not
// get collision information