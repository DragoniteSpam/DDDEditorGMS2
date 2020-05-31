/// @param buffer
/// @param DataFlagZone
/// @param version

var buffer = argument0;
var zone = argument1;
var version = argument2;

serialize_load_zone(buffer, zone, version);

zone.zone_flags = buffer_read(buffer, buffer_u32);