/// @param buffer
/// @param DataCameraZone
/// @param version
function serialize_load_zone_camera(argument0, argument1, argument2) {

	var buffer = argument0;
	var zone = argument1;
	var version = argument2;

	serialize_load_zone(buffer, zone, version);

	zone.camera_distance = buffer_read(buffer, buffer_u16);
	zone.camera_angle = buffer_read(buffer, buffer_f32);
	zone.camera_easing_method = buffer_read(buffer, buffer_u8);
	zone.camera_easing_time = buffer_read(buffer, buffer_f32);


}
