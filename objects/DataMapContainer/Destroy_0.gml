if (contents) {
	instance_activate_object(contents);
	instance_destroy(contents);
}

if (data_buffer) buffer_delete(data_buffer);