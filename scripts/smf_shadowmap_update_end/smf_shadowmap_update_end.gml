/// @description smf_shadowmap_update_end()
function smf_shadowmap_update_end() {
	shader_reset();
	surface_reset_target();
	matrix_set(matrix_world, SMF_MATIDENTITY);


}
