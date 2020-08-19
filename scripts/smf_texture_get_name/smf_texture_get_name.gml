/// @description smf_texture_get_name(index)
/// @param index
function smf_texture_get_name(argument0) {
    name = SMF_textureList[| argument0 + 1]
    if is_undefined(name){return "TextureNotInSMFSystem";}
    return name;


}
