/// @param UIList
/// @param x
/// @param y

// no alphabetize
var oldentries = argument0.entries;
argument0.entries = Stuff.all_bgm;
ui_render_list(argument0, argument1, argument2);
argument0.entries = oldentries;