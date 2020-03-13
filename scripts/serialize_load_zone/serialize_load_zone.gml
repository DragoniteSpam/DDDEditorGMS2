/// @param buffer
/// @param DataCameraZone
/// @param version

var buffer = argument0;
var zone = argument1;
var version = argument2;

zone.name = buffer_read(buffer, buffer_string);
zone.x1 = buffer_read(buffer, buffer_f32);
zone.y1 = buffer_read(buffer, buffer_f32);
zone.z1 = buffer_read(buffer, buffer_f32);
zone.x2 = buffer_read(buffer, buffer_f32);
zone.y2 = buffer_read(buffer, buffer_f32);
zone.z2 = buffer_read(buffer, buffer_f32);
zone.zone_priority = buffer_read(buffer, buffer_u16);