/// @param buffer

var sw = buffer_read(argument0, buffer_u16);
var sh = buffer_read(argument0, buffer_u16);
var slength = sw * sh * 4;
var sbuffer = buffer_create(slength, buffer_grow, 1);
var surface = surface_create(sw, sh);
	
buffer_copy(argument0, buffer_tell(argument0), slength, sbuffer, 0);
buffer_seek(argument0, buffer_seek_relative, slength);
buffer_set_surface(sbuffer, surface, 0, 0, 0);
	
var sprite = sprite_create_from_surface(surface, 0, 0, sw, sh, false, false, 0, 0);
	
buffer_delete(sbuffer);
surface_free(surface);

return sprite;