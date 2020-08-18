/// @param buffer
/// @param DataCameraZone
function serialize_save_zone_light(argument0, argument1) {

	var buffer = argument0;
	var zone = argument1;

	serialize_save_zone(buffer, zone);

	var n_active = ds_list_size(zone.active_lights);
	buffer_write(buffer, buffer_u8, n_active);
	for (var i = 0; i < n_active; i++) {
	    buffer_write(buffer, buffer_datatype, zone.active_lights[| i]);
	}


}
