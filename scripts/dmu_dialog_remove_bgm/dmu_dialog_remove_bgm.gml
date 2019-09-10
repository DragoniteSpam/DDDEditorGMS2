/// @param UIThing

var thing = argument0;

var selection = ui_list_selection(thing.root.el_list);

if (selection) {
    audio_remove_bgm(Stuff.all_bgm[| selection].GUID);
    ui_list_deselect(thing.root.el_list);
}