/// @description smf_texture_get_index(name)
/// @param name
function smf_texture_get_sprite(argument0) {
    var i = ds_list_find_index(SMF_textureList, argument0);
    if i != -1
    {
        return SMF_textureList[| i - 1];
    }
    else
    {
        return -1;
    }


}
