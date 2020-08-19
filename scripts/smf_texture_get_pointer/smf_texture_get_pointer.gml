/// @description smf_texture_get_pointer(name)
/// @param name
function smf_texture_get_pointer(argument0) {
    var i = ds_list_find_index(SMF_textureList, argument0);
    if i != -1
    {
        return sprite_get_texture(SMF_textureList[| i - 1], 0);
    }
    else
    {
        return -1;
    }


}
