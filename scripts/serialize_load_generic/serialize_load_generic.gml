/// @param buffer
/// @param Data
/// @param version

var buffer = argument0;
var data = argument1;
var version = argument2;

data.name = buffer_read(buffer, buffer_string);
internal_name_set(data, buffer_read(buffer, buffer_string));
data.flags = buffer_read(buffer, buffer_u32);
guid_set(data, buffer_read(buffer, buffer_u32));

if (version >= DataVersions.SUMMARY_GENERIC_DATA) {
    data.summary = buffer_read(buffer, buffer_string);
}