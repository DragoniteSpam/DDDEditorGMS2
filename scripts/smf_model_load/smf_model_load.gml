/// @description smf_model_load_from_buffer(fname)
/// @param fname
function smf_model_load(argument0) {
	/*
	Load an SMF model
	Returns the index of the model

	Script made by TheSnidr
	www.TheSnidr.com
	*/
	var path, loadBuff, version, size, vertBuff, vBuff, n, vertList, modelName, texPos, matPos, modPos, nodPos, colPos, rigPos, aniPos, selPos;
	var fname = argument0;
	var buff = buffer_load(fname);
	if buff < 0
	{
	    show_debug_message("Could not load model " + string(fname));
	    return undefined;
	}
	var modelIndex = smf_model_load_from_buffer(buff, filename_name(fname));
	return [buff, modelIndex];


}
