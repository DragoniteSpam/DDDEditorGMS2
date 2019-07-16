/// @param UIThing

var selection = ui_list_selection(argument0.root.el_list);

if (selection) {
    // no alphabetize
    audio_remove_se(Stuff.all_se[| selection].GUID);
    ui_list_deselect(argument0.root.el_list);
}