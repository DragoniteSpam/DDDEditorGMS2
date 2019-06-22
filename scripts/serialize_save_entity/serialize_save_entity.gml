/// @param buffer
/// @param Entity

buffer_write(argument0, buffer_string, argument1.name);
buffer_write(argument0, buffer_u32, argument1.xx);
buffer_write(argument0, buffer_u32, argument1.yy);
buffer_write(argument0, buffer_u32, argument1.zz);

buffer_write(argument0, buffer_u32, argument1.GUID);

var entity_bools = pack(argument1.am_solid, argument1.static,
    argument1.animate_idle, argument1.animate_movement, argument1.direction_fix);
buffer_write(argument0, buffer_u32, entity_bools);

var n_events = ds_list_size(argument1.object_events);
buffer_write(argument0, buffer_u8, n_events);
for (var i = 0; i < n_events; i++) {
    serialize_save_entity_event_page(argument0, argument1.object_events[| i]);
}

buffer_write(argument0, buffer_f32, argument1.off_xx);
buffer_write(argument0, buffer_f32, argument1.off_yy);
buffer_write(argument0, buffer_f32, argument1.off_zz);

buffer_write(argument0, buffer_u16, argument1.rot_xx);
buffer_write(argument0, buffer_u16, argument1.rot_yy);
buffer_write(argument0, buffer_u16, argument1.rot_zz);

buffer_write(argument0, buffer_f32, argument1.scale_xx);
buffer_write(argument0, buffer_f32, argument1.scale_yy);
buffer_write(argument0, buffer_f32, argument1.scale_zz);

buffer_write(argument0, buffer_u8, argument1.autonomous_movement);
buffer_write(argument0, buffer_u8, argument1.autonomous_movement_speed);
buffer_write(argument0, buffer_u8, argument1.autonomous_movement_frequency);
buffer_write(argument0, buffer_u32, argument1.autonomous_movement_route);

var n_move_routes = ds_list_size(argument1.movement_routes);
buffer_write(argument0, buffer_u8, n_move_routes);

for (var i = 0; i < n_move_routes; i++) {
    serialize_save_move_route(argument0, argument1.movement_routes[| i]);
}