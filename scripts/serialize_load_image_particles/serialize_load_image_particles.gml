/// @param buffer
/// @param version
function serialize_load_image_particles(argument0, argument1) {

	var buffer = argument0;
	var version = argument1;
	var list = Stuff.all_graphic_particles;

	var addr_next = buffer_read(buffer, buffer_u64);

	ds_list_clear_instances(list);

	var n_images = buffer_read(buffer, buffer_u32);
	var individual_images = buffer_read(buffer, buffer_u8);

	repeat (n_images) {
	    var data = instance_create_depth(0, 0, 0, DataImage);
    
	    serialize_load_generic(buffer, data, version);
	    data.hframes = buffer_read(buffer, buffer_u16);
	    data.vframes = buffer_read(buffer, buffer_u16);
	    data.x = buffer_read(buffer, buffer_f32);
	    data.y = buffer_read(buffer, buffer_f32);
	    data.width = buffer_read(buffer, buffer_f32);
	    data.height = buffer_read(buffer, buffer_f32);
    
	    data.aspeed = buffer_read(buffer, buffer_f32);
    
	    var bools = buffer_read(buffer, buffer_u32);
	    data.texture_exclude = unpack(bools, 0);
    
	    if (individual_images) {
	        data.picture = buffer_read_sprite(buffer);
	    }
    
	    ds_list_add(list, data);
	}

	if (!individual_images) {
	    not_yet_implemented();
	}


}
