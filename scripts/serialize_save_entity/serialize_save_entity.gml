/// @param buffer
/// @param Entity

var buffer = argument0;
var entity = argument1;

buffer_write(buffer, buffer_string, entity.name);
buffer_write(buffer, buffer_u32, entity.xx);
buffer_write(buffer, buffer_u32, entity.yy);
buffer_write(buffer, buffer_u32, entity.zz);

buffer_write(buffer, buffer_u32, entity.REFID);

var entity_bools = pack(entity.am_solid, entity.static,
    entity.animate_idle, entity.animate_movement, entity.direction_fix,
    entity.reset_position
);
buffer_write(buffer, buffer_u32, entity_bools);

var n_events = ds_list_size(entity.object_events);
buffer_write(buffer, buffer_u8, n_events);
for (var i = 0; i < n_events; i++) {
    serialize_save_entity_event_page(buffer, entity.object_events[| i]);
}

buffer_write(buffer, buffer_f32, entity.off_xx);
buffer_write(buffer, buffer_f32, entity.off_yy);
buffer_write(buffer, buffer_f32, entity.off_zz);

buffer_write(buffer, buffer_u16, entity.rot_xx);
buffer_write(buffer, buffer_u16, entity.rot_yy);
buffer_write(buffer, buffer_u16, entity.rot_zz);

buffer_write(buffer, buffer_f32, entity.scale_xx);
buffer_write(buffer, buffer_f32, entity.scale_yy);
buffer_write(buffer, buffer_f32, entity.scale_zz);

buffer_write(buffer, buffer_u8, entity.autonomous_movement);
buffer_write(buffer, buffer_u8, entity.autonomous_movement_speed);
buffer_write(buffer, buffer_u8, entity.autonomous_movement_frequency);
buffer_write(buffer, buffer_u32, entity.autonomous_movement_route);

var n_move_routes = ds_list_size(entity.movement_routes);
buffer_write(buffer, buffer_u8, n_move_routes);

for (var i = 0; i < n_move_routes; i++) {
    serialize_save_move_route(buffer, entity.movement_routes[| i]);
}

// these two lists are the same size and won't really be changing sizes
var n_variables = ds_list_size(entity.switches);
buffer_write(buffer, buffer_u8, n_variables);

for (var i = 0; i < n_variables; i++) {
    buffer_write(buffer, buffer_bool, entity.switches[| i]);
    buffer_write(buffer, buffer_f32, entity.variables[| i]);
}