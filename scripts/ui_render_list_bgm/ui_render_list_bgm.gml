/// @param UIList
/// @param x
/// @param y

var oldentries = argument0.entries;

if (Stuff.setting_alphabetize_lists) {
    argument0.entries = ds_list_sort_name_sucks(Stuff.all_bgm);
} else {
    argument0.entries = Stuff.all_bgm;
}

ui_render_list(argument0, argument1, argument2);

if (Stuff.setting_alphabetize_lists) {
    ds_list_destroy(argument0.entries);
}

// no memory leak, although the list isn't used
argument0.entries = oldentries;