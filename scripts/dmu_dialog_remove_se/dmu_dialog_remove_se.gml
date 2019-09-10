/// @param UIThing

var thing = argument0;
var selection = ui_list_selection(thing.root.el_list);
ui_list_deselect(thing.root.el_list);

if (selection) {
    audio_remove_se(Stuff.all_se[| selection].GUID);
}