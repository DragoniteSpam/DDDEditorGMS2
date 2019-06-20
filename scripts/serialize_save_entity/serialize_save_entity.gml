/// @param buffer
/// @param Entity

buffer_write(argument0, buffer_string, argument1.name);
buffer_write(argument0, buffer_u32, argument1.xx);
buffer_write(argument0, buffer_u32, argument1.yy);
buffer_write(argument0, buffer_u32, argument1.zz);

// this next line only is for DataVersions.ENTITY_GUID and beyond only
buffer_write(argument0, buffer_u32, argument1.GUID);

var entity_bools = pack(argument1.am_solid, argument1.static,
    // DataVersions.ENTITY_MAP_OPTIONS_WHOOPS
    argument1.animate_idle, argument1.animate_movement, argument1.direction_fix);
buffer_write(argument0, buffer_u32, entity_bools);

// DataVersions.MAP_ENTITY_EVENTS
var n_events = ds_list_size(argument1.object_events);
buffer_write(argument0, buffer_u8, n_events);
for (var i = 0; i < n_events; i++) {
    serialize_save_entity_event_page(argument0, argument1.object_events[| i]);
}

// DataVersions.ENTITY_TRANSFORM

buffer_write(argument0, buffer_f32, argument1.off_xx);
buffer_write(argument0, buffer_f32, argument1.off_yy);
buffer_write(argument0, buffer_f32, argument1.off_zz);

buffer_write(argument0, buffer_u16, argument1.rot_xx);
buffer_write(argument0, buffer_u16, argument1.rot_yy);
buffer_write(argument0, buffer_u16, argument1.rot_zz);

buffer_write(argument0, buffer_f32, argument1.scale_xx);
buffer_write(argument0, buffer_f32, argument1.scale_yy);
buffer_write(argument0, buffer_f32, argument1.scale_zz);

// DataVersions.OPTIONS_ON_ENTITIES_WORKS

buffer_write(argument0, buffer_u8, argument1.autonomous_movement);
buffer_write(argument0, buffer_u8, argument1.autonomous_movement_speed);
buffer_write(argument0, buffer_u8, argument1.autonomous_movement_frequency);
// corrected in DataVersions.MOVE_ROUTES, was previously a u8
buffer_write(argument0, buffer_u32, argument1.autonomous_movement_route);

var n_move_routes = ds_list_size(argument1.movement_routes);
buffer_write(argument0, buffer_u8, n_move_routes);

for (var i = 0; i < n_move_routes; i++) {
    // DataVersions.MOVE_ROUTES
    serialize_save_move_route(argument0, argument1.movement_routes[| i]);
}