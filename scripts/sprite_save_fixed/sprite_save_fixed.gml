/// @param sprite
/// @param subimg
/// @param path
function sprite_save_fixed() {
	// by yellowafterlife

	var sprite = argument[0];
	var frame = argument[1];
	var fn = argument[2];

	var t = sprite_to_surface(sprite, frame);
	surface_save(t, fn);
	surface_free(t);


}
