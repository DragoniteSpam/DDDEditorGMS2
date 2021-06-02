/// @param buffer
/// @param DataCameraZone
/// @param version
function serialize_load_zone_light(argument0, argument1, argument2) {

    var buffer = argument0;
    var zone = argument1;
    var version = argument2;

    serialize_load_zone(buffer, zone, version);

    var n_active = buffer_read(buffer, buffer_u8);
    array_resize(zone.active_lights, min(n_active, MAX_LIGHTS));
    var index = 0;
    repeat (n_active) {
        var data = buffer_read(buffer, buffer_datatype);
        if (index < MAX_LIGHTS) {
            zone.active_lights[@ index++] = data;
        }
    }


}
