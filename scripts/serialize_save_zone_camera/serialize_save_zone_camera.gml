/// @param buffer
/// @param DataCameraZone
function serialize_save_zone_camera(argument0, argument1) {

    var buffer = argument0;
    var zone = argument1;

    serialize_save_zone(buffer, zone);

    buffer_write(buffer, buffer_u16, zone.camera_distance);
    buffer_write(buffer, buffer_f32, zone.camera_angle);
    buffer_write(buffer, buffer_u8, zone.camera_easing_method);
    buffer_write(buffer, buffer_f32, zone.camera_easing_time);


}
