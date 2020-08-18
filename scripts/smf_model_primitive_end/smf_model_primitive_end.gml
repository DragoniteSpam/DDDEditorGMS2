/// @description smf_model_primitive_end(modelIndex);
/// @param modelIndex
function smf_model_primitive_end(argument0) {
	var modelIndex = argument0;
	var bufArray = modelIndex[| SMF_model.MBuff];

	var vBuff = vertex_create_buffer_from_buffer(bufArray[0], SMF_format);
	modelIndex[| SMF_model.VBuff] = [vBuff];
	vertex_freeze(vBuff);


}
