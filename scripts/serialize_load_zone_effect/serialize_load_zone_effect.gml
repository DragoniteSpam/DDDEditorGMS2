/// @param buffer
/// @param DataCameraZone
/// @param version

var buffer = argument0;
var zone = argument1;
var version = argument2;

serialize_load_zone(buffer, zone, version);

ds_list_clear(zone.active_lights);
var n_active = buffer_read(buffer, buffer_u8);
repeat (n_active) {
    ds_list_add(zone.active_lights, buffer_read(buffer, buffer_datatype));
}