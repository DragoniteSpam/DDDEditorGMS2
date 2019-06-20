/// @param buffer
/// @param sprite

var surface = sprite_to_surface(argument1, 0);
var sw = surface_get_width(surface);
var sh = surface_get_height(surface);
var slength = sw * sh * 4;
	
var sbuffer = buffer_create(slength, buffer_fixed, 1);
var size = buffer_get_size(sbuffer);
buffer_get_surface(sbuffer, surface, 0, 0, 0);
buffer_write(argument0, buffer_u16, sw);
buffer_write(argument0, buffer_u16, sh);
buffer_resize(argument0, buffer_get_size(argument0) + size);
buffer_copy(sbuffer, 0, buffer_get_size(sbuffer), argument0, buffer_tell(argument0));
buffer_seek(argument0, buffer_seek_relative, size);
    
surface_free(surface);
buffer_delete(sbuffer);