/// @description smf_texture_get_index(index)
/// @param index
function smf_texture_exists(argument0) {
	if ds_list_find_index(SMF_textureList, argument0) == -1{return false;}
	return true;


}
