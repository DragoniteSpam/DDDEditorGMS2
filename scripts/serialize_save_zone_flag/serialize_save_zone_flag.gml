/// @param buffer
/// @param DataFlagZone

var buffer = argument0;
var zone = argument1;

serialize_save_zone(buffer, zone);

buffer_write(buffer, buffer_u32, zone.zone_flags);