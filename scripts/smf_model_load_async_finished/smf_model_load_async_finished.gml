/// @description smf_async_finished()
function smf_model_load_async_finished() {
	//Returns true if there are no more models in line for asynchronous loading
	return (ds_list_size(SMF_asyncLoadList) == 0)


}
