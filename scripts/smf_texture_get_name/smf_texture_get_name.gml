/// @description smf_texture_get_name(index)
/// @param index
name = SMF_textureList[| argument0 + 1]
if is_undefined(name){return "TextureNotInSMFSystem";}
return name;