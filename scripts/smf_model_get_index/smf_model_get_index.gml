/// @description smf_get_model(name)
/// @param name
function smf_model_get_index(argument0) {
	var modelName = string(argument0);
	var index = ds_list_find_index(SMF_modelList, modelName);
	if index == -1{
	    index = ds_list_find_index(SMF_modelList, modelName + ".smf");
	    if index == -1{
	        index = ds_list_find_index(SMF_modelList, filename_name(modelName));
	        if index == -1{
	            index = ds_list_find_index(SMF_modelList, filename_name(modelName) + ".smf");
	            if index == -1{
	                show_debug_message("ERROR in smf_get_model: Cannot find model " + string(modelName));
	                return -1;}}}}
	return SMF_modelList[| index - 1];


}
