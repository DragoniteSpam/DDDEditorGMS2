/// @description smf_replace_texture(sprite_index, name, internal)
/// @param sprite_index
/// @param name
/// @param external
function smf_texture_add(argument0, argument1, argument2) {
    /*
    This script lets you replace a texture in the SMF texture list.
    This is extremely useful if you have compiled models and have a lot of textures
    on a single texture page, as you can then load the texture into GMS so that it
    won't have to be loaded externally. Loading textures externally uses much more
    memory than GM's native sprites, so this gives an enormous memory advantage!
    */
    var spr = argument0;
    var name = argument1;
    var external = argument2;
    var i = ds_list_find_index(SMF_textureList, name);
    if i != -1
    {
        show_debug_message("Trying to add a sprite " + string(name) + " that already exists! The sprite has been replaced instead");
        if sprite_exists(SMF_textureList[| i - 1]) and SMF_textureList[| i - 1] != spr{
            sprite_delete(SMF_textureList[| i - 1]);}
        SMF_textureList[| i - 1] = spr;
        return i - 1;
    }
    else
    {
        ds_list_add(SMF_textureList, spr, name, external);
    }
    return ds_list_size(SMF_textureList) - 3;


}
