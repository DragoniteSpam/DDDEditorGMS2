/// @description smf_shadowmap_destroy(index)
/// @param shadowmap
function smf_shadowmap_destroy(argument0) {
	//Destroy a shadowmap
	var shadowmap = argument0;
	if surface_exists(shadowmap[| SMF_shadowmap.surface]){
	    surface_free(shadowmap[| SMF_shadowmap.surface]);}
	ds_list_destroy(shadowmap);


}
