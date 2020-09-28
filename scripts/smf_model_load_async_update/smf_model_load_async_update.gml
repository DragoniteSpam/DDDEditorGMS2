/// @description smf_async_load_end()
function smf_model_load_async_update() {
    //Place in Async Save/Load event
    if async_load[? "id"] != SMF_asyncHandle{exit;}
    if async_load[? "status"] == false{
        SMF_asyncLoadText = "ERROR: Failed to load " + filename_name(SMF_asyncFileName);
        show_debug_message(SMF_asyncLoadText);
        exit;}

    var modelIndex = smf_model_load_from_buffer(SMF_asyncBuffer, filename_name(SMF_asyncFileName));

    ds_list_delete(SMF_asyncLoadList, 0);

    if ds_list_size(SMF_asyncLoadList) != 0
    {
        buffer_resize(SMF_asyncBuffer, 1);
        SMF_asyncFileName = SMF_asyncLoadList[| 0]; 
        SMF_asyncLoadText = "Loading model " + filename_name(SMF_asyncFileName);
        SMF_asyncHandle = buffer_load_async(SMF_asyncBuffer, SMF_asyncFileName, 0, -1);
        show_debug_message(SMF_asyncLoadText);
    }
    else
    {
        SMF_asyncLoadText = "Successfully loaded all models";
    }

    return modelIndex;


}
