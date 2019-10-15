/// @description smf_texture_get_index(name)
/// @param name
var i = ds_list_find_index(SMF_textureList, argument0);
if i != -1
{
	return i - 1;
}
else
{
	return -1;
}