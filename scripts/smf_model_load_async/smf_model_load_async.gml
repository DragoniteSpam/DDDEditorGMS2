/// @description smf_model_load_async(fname)
/// @param fname
var fname = argument0;
if smf_model_load_async_finished()
{
	buffer_resize(SMF_asyncBuffer, 1);
	SMF_asyncFileName = fname;
	SMF_asyncLoadText = "Loading model " + filename_name(SMF_asyncFileName);
	SMF_asyncHandle = buffer_load_async(SMF_asyncBuffer, SMF_asyncFileName, 0, -1);
	show_debug_message(SMF_asyncLoadText);
}
ds_list_add(SMF_asyncLoadList, fname);