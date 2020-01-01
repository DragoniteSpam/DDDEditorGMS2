/// @param buffer
/// @param file-data

var buffer = argument0;
var file_data = argument1;

buffer_write(buffer, buffer_u8, $44);
buffer_write(buffer, buffer_u8, $44);
buffer_write(buffer, buffer_u8, $44);
buffer_write(buffer, buffer_u32, DataVersions._CURRENT - 1);
buffer_write(buffer, buffer_u8, SERIALIZE_DATA_AND_MAP);

buffer_write(buffer, buffer_u8, file_data.compressed);
buffer_write(buffer, buffer_string, "// @todo author string");
buffer_write(buffer, buffer_u16, current_year);
buffer_write(buffer, buffer_u8, current_month);
buffer_write(buffer, buffer_u8, current_day);
buffer_write(buffer, buffer_u8, current_hour);
buffer_write(buffer, buffer_u8, current_minute);
buffer_write(buffer, buffer_u8, current_second);