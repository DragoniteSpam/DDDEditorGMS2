/// @param buffer

var sw = buffer_read(argument0, buffer_u16);
var sh = buffer_read(argument0, buffer_u16);
var slength = sw * sh * 4;
var surface = surface_create(sw, sh);
var sbuffer = buffer_read_buffer(argument0, slength); 

buffer_set_surface(sbuffer, surface, buffer_surface_copy, 0, 0);

var sprite = sprite_create_from_surface(surface, 0, 0, sw, sh, false, false, 0, 0);

buffer_delete(sbuffer);
surface_free(surface);

return sprite;