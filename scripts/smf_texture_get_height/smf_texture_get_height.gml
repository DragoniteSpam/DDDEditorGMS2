/// @description smf_texture_get_height(index)
/// @param index
function smf_texture_get_height(argument0) {
	spr = SMF_textureList[| argument0]
	if is_undefined(spr){return -1;}
	return sprite_get_height(spr);


}
