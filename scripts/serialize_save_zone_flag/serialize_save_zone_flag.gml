/// @param buffer
/// @param DataFlagZone
function serialize_save_zone_flag(argument0, argument1) {

	var buffer = argument0;
	var zone = argument1;

	serialize_save_zone(buffer, zone);

	buffer_write(buffer, buffer_u32, zone.zone_flags);


}
