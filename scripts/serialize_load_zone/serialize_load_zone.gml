/// @param buffer
/// @param DataCameraZone
/// @param version
function serialize_load_zone(argument0, argument1, argument2) {

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

    map_zone_collision(zone);


}
