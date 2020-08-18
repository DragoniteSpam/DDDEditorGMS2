/// @param buffer
/// @param DataCameraZone
/// @param version
function serialize_load_zone_light(argument0, argument1, argument2) {

	var buffer = argument0;
	var zone = argument1;
	var version = argument2;

	serialize_load_zone(buffer, zone, version);

	ds_list_clear(zone.active_lights);
	var n_active = buffer_read(buffer, buffer_u8);
	repeat (n_active) {
	    var data = buffer_read(buffer, buffer_get_datatype(version));
	    if (ds_list_size(zone.active_lights) < MAX_LIGHTS) {
	        ds_list_add(zone.active_lights, data);
	    }
	}


}
