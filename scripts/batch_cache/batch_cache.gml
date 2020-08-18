function batch_cache() {
	var map_contents = Stuff.map.active_map.contents;

	var buffer = vertex_create_buffer();
	var buffer_wire = vertex_create_buffer();
	vertex_begin(buffer, Stuff.graphics.vertex_format);
	vertex_begin(buffer_wire, Stuff.graphics.vertex_format);

	var batch_data = ds_map_create();
	ds_list_add(map_contents.batch_data, batch_data);
	ds_list_mark_as_map(map_contents.batch_data, ds_list_size(map_contents.batch_data) - 1);
	var instance_list = ds_list_create();
	ds_map_add_list(batch_data, "instances", instance_list);
	batch_data[? "vertex"] = buffer;
	batch_data[? "wire"] = buffer_wire;

	for (var i = 0; i < ds_list_size(map_contents.batch_in_the_future); i++) {
	    var thing = map_contents.batch_in_the_future[| i];
	    thing.batch_addr = ds_list_top(map_contents.batch_data);
	    // see comments on the buffer in batch_again
	    var results = script_execute(thing.batch, buffer, buffer_wire, thing);
	    buffer = results[0];
	    buffer_wire = results[1];
    
	    ds_list_add(instance_list, thing);
	}

	vertex_end(buffer);
	vertex_freeze(buffer);
	vertex_end(buffer_wire);
	vertex_freeze(buffer_wire);

	ds_list_clear(map_contents.batch_in_the_future);


}
