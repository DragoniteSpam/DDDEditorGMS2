/// @param buffer
/// @param Data

var buffer = argument0;
var data = argument1;

buffer_write(buffer, buffer_string, data.name);
buffer_write(buffer, buffer_string, data.internal_name);
buffer_write(buffer, buffer_u32, data.flags);
buffer_write(buffer, buffer_datatype, data.GUID);
buffer_write(buffer, buffer_string, data.summary);