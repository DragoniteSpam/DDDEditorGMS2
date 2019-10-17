/// @param UIThing

var thing = argument0;
var selection = ui_list_selection(thing.root.el_list);
ui_list_deselect(thing.root.el_list);

if (selection + 1) {
    graphics_remove_battler(Stuff.all_graphic_battlers[| selection].GUID);
    ui_list_deselect(thing.root.el_list);
}