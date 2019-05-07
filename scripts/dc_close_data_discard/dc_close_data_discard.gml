/// @description  void dc_close_data_discard(Dialog, [force?]);
/// @param Dialog
/// @param  [force?]

// for whatever dumb reason, the original objects are the ones
// that get changed. so delete the original objects and replace
// them with the cached ones.

ds_list_destroy_instances_indirect(Stuff.all_data);

Stuff.all_data=Stuff.original_data;
Stuff.original_data=noone;
data_apply_all_guids(Stuff.all_data);

dc_close_no_questions_asked(argument0);
