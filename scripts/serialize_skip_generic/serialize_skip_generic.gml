/// @param buffer
/// @param version
function serialize_skip_generic(argument0, argument1) {

    var version = argument1;

    buffer_read(argument0, buffer_string);
    buffer_read(argument0, buffer_string);
    buffer_read(argument0, buffer_u32);
    buffer_read(argument0, buffer_u32);


}
