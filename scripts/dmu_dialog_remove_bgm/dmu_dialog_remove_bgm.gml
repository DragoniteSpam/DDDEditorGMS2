/// @param UIThing

var selection = ui_list_selection(argument0.root.el_list);

if (selection) {
    // no alphabetize
    audio_remove_bgm(Stuff.all_bgm[| selection].GUID);
    ui_list_deselect(argument0.root.el_list);
}