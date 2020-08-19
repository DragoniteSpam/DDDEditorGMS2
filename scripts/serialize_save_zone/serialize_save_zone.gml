/// @param buffer
/// @param DataCameraZone
function serialize_save_zone(argument0, argument1) {

    var buffer = argument0;
    var zone = argument1;

    buffer_write(buffer, buffer_string, zone.name);
    buffer_write(buffer, buffer_f32, zone.x1);
    buffer_write(buffer, buffer_f32, zone.y1);
    buffer_write(buffer, buffer_f32, zone.z1);
    buffer_write(buffer, buffer_f32, zone.x2);
    buffer_write(buffer, buffer_f32, zone.y2);
    buffer_write(buffer, buffer_f32, zone.z2);
    buffer_write(buffer, buffer_u16, zone.zone_priority);


}
