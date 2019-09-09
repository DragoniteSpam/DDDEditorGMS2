/// @param buffer
/// @param Entity
/// @param version

var buffer = argument0;
var entity = argument1;
var version = argument2;

entity.name = buffer_read(buffer, buffer_string);
entity.xx = buffer_read(buffer, buffer_u32);
entity.yy = buffer_read(buffer, buffer_u32);
entity.zz = buffer_read(buffer, buffer_u32);
refid_set(entity, buffer_read(buffer, buffer_u32));

var state_solid = entity.am_solid;
var state_static = entity.static;

var entity_bools = buffer_read(buffer, buffer_u32);
entity.am_solid = unpack(entity_bools, 0);
entity.static = unpack(entity_bools, 1);
entity.animate_idle = unpack(entity_bools, 2);
entity.animate_movement = unpack(entity_bools, 3);
entity.direction_fix = unpack(entity_bools, 4);
entity.reset_position = unpack(entity_bools, 5);

// meshes and pawns are solid by default, so if the state of their
// solidness changes, this needs to be reflected in the map stats counter
if (state_solid && !entity.am_solid) {
    Stuff.active_map.population_solid--;
} else if (!state_solid && entity.am_solid) {
    Stuff.active_map.population_solid++;
}

// same for statics
if (state_static && !entity.static) {
    Stuff.active_map.population_static--;
} else if (!state_static && entity.static) {
    Stuff.active_map.population_static++;
}

var n_events = buffer_read(buffer, buffer_u8);
repeat(n_events) {
    serialize_load_entity_event_page(buffer, entity, version);
}

entity.off_xx = buffer_read(buffer, buffer_f32);
entity.off_yy = buffer_read(buffer, buffer_f32);
entity.off_zz = buffer_read(buffer, buffer_f32);
    
entity.rot_xx = buffer_read(buffer, buffer_u16);
entity.rot_yy = buffer_read(buffer, buffer_u16);
entity.rot_zz = buffer_read(buffer, buffer_u16);
    
entity.scale_xx = buffer_read(buffer, buffer_f32);
entity.scale_yy = buffer_read(buffer, buffer_f32);
entity.scale_zz = buffer_read(buffer, buffer_f32);

entity.autonomous_movement = buffer_read(buffer, buffer_u8);
entity.autonomous_movement_speed = buffer_read(buffer, buffer_u8);
entity.autonomous_movement_frequency = buffer_read(buffer, buffer_u8);
entity.autonomous_movement_route = buffer_read(buffer, buffer_u32);
    
var n_move_routes = buffer_read(buffer, buffer_u8);
repeat(n_move_routes) {
    serialize_load_move_route(buffer, entity, version);
}

ds_list_clear(entity.switches);
ds_list_clear(entity.variables);

var n_variables = buffer_read(buffer, buffer_u8);
repeat (n_variables) {
    ds_list_add(entity.switches, buffer_read(buffer, buffer_bool));
    ds_list_add(entity.variables, buffer_read(buffer, buffer_f32));
}

while (ds_list_size(entity.switches) < BASE_SELF_VARIABLES) {
    ds_list_add(entity.switches, false);
}
while (ds_list_size(entity.variables) < BASE_SELF_VARIABLES) {
    ds_list_add(entity.variables, 0);
}

// this should not be instantiated on its own and does not
// get collision information