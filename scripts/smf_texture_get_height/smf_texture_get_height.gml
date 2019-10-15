/// @description smf_texture_get_height(index)
/// @param index
spr = SMF_textureList[| argument0]
if is_undefined(spr){return -1;}
return sprite_get_height(spr);