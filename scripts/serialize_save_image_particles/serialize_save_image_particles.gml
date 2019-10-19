/// @param buffer

var buffer = argument0;

buffer_write(buffer, buffer_datatype, SerializeThings.IMAGE_PARTICLES);
var list = Stuff.all_graphic_particles;

var n_images = ds_list_size(list);
buffer_write(buffer, buffer_u32, n_images);

var individual_images = (n_images < 100) && true;
buffer_write(buffer, buffer_u8, individual_images);

for (var i = 0; i < n_images; i++) {
    var data = list[| i];
    
    serialize_save_generic(buffer, data);
    buffer_write(buffer, buffer_u16, data.hframes);
    buffer_write(buffer, buffer_u16, data.vframes);
    buffer_write(buffer, buffer_f32, data.x);
    buffer_write(buffer, buffer_f32, data.y);
    buffer_write(buffer, buffer_f32, data.width);
    buffer_write(buffer, buffer_f32, data.height);
    
    if (individual_images) {
        buffer_write_sprite(buffer, data.picture);
    }
}

if (!individual_images) {
    buffer_write_sprite(buffer, Stuff.all_graphic_particle_texture);
}