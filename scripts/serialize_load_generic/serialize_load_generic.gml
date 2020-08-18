/// @param buffer
/// @param Data
/// @param version
function serialize_load_generic(argument0, argument1, argument2) {

	var buffer = argument0;
	var data = argument1;
	var version = argument2;

	data.name = buffer_read(buffer, buffer_string);
	internal_name_set(data, buffer_read(buffer, buffer_string));
	data.flags = buffer_read(buffer, buffer_u32);
	guid_set(data, buffer_read(buffer, buffer_get_datatype(version)));
	data.summary = buffer_read(buffer, buffer_string);


}
