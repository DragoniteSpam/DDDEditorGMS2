/// @param filename
/// @param [adjust-UVs?]
function import_qma() {

	var buffer = buffer_load(argument[0]);
	var adjust = (argument_count > 1 && argument[1] != undefined) ? argument[1] : true;

	var data = json_decode(buffer_read(buffer, buffer_string));

	var version = data[? "version"];

	ds_map_destroy(data);

	var n = buffer_read(buffer, buffer_u32);

	repeat (n) {
	    var mesh = import_qma_next(buffer);
	}

	buffer_delete(buffer);


}
