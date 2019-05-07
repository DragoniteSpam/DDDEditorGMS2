/// @description  void dc_data_commit(UIButton);
/// @param UIButton
// if there will be any conflicts, panic and explode, i mean, confirm them

if (argument0.root.changed&&ds_list_size(Stuff.original_data)>0){
    var dw=560;
    var dh=440;
    
    var dg=dialog_create(dw, dh, "this is important", dialog_default, dc_close_no_questions_asked, argument0);
    
    var b_width=128;
    var b_height=32;
    
    var el_text=create_text(dw/2, dh*2/5, "We have detected that you may have made some important changes to the game data. We have not detected if this may cause conflicts with anything else, but if there any, they will be resolved by being nuked. Okay?##(If you've deleted data types or properties but aren't certain if you're going to want them back, it's probably best to just have them and not use them - you can have them exist in the data file but be discarded by the game)##((You can cancel changes instead by clicking the X at the top of the window))", 0, 0, fa_center, dw-96, dg);
    var el_cancel=create_button(dw/4-b_width/2, dh-32-b_height/2, "wait no stop", b_width, b_height, fa_center, dmu_dialog_commit, dg);
    var el_why=create_button(dw/2-b_width/2, dh-32-b_height/2, "why?", b_width, b_height, fa_center, dc_data_why, dg);
    var el_confirm=create_button(dw*3/4-b_width/2, dh-32-b_height/2, "yeah go ahead", b_width, b_height, fa_center, dc_data_commit_seriously, dg);
    
    ds_list_add(dg.contents, el_text, el_cancel, el_why, el_confirm);
} else {
    // if you're okay, discard the cache
    ds_list_destroy_instances(Stuff.original_data);
    dc_close_no_questions_asked(argument0);
}

// but only if you're already in the data editor mode
if (Camera.mode==EditorModes.EDITOR_DATA){
    momu_editor_data(noone);
}
