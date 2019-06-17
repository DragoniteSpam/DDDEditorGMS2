/// @param UIList
/// @param x
/// @param y

ds_list_clear(argument0.entries);

if (Stuff.setting_alphabetize_lists) {
    var priority = ds_priority_create();
    for (var i = 0; i < ds_list_size(Stuff.all_bgm); i++) {
        var data = Stuff.all_bgm[| i];
        ds_priority_add(priority, data[@ AudioProperties.NAME], data[@ AudioProperties.NAME]);
    }
    while (!ds_priority_empty(priority)) {
        ds_list_add(argument0.entries, ds_priority_delete_min(priority));
    }
    ds_priority_destroy(priority);
} else {
    for (var i = 0; i < ds_list_size(Stuff.all_bgm); i++) {
        var data = Stuff.all_bgm[| i];
        ds_list_add(argument0.entries, data[@ AudioProperties.NAME]);
    }
}

ui_render_list(argument0, argument1, argument2);