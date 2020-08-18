/// @param buffer
function serialize_save_image_skybox(argument0) {

	var buffer = argument0;
	var list = Stuff.all_graphic_skybox;

	buffer_write(buffer, buffer_u32, SerializeThings.IMAGE_SKYBOX);
	var addr_next = buffer_tell(buffer);
	buffer_write(buffer, buffer_u64, 0);

	var n_images = ds_list_size(list);
	buffer_write(buffer, buffer_u32, n_images);

	for (var i = 0; i < n_images; i++) {
	    var data = list[| i];
    
	    serialize_save_generic(buffer, data);
	    buffer_write(buffer, buffer_f32, data.x);
	    buffer_write(buffer, buffer_f32, data.y);
	    buffer_write(buffer, buffer_f32, data.width);
	    buffer_write(buffer, buffer_f32, data.height);
    
	    var bools = pack(0);
	    buffer_write(buffer, buffer_u32, bools);
    
	    buffer_write_sprite(buffer, data.picture);
	}

	buffer_poke(buffer, addr_next, buffer_u64, buffer_tell(buffer));

	return buffer_tell(buffer);


}
