/// @param UIList
/// @param x
/// @param y

// this is a lot of the same code as ui_render_list which annoys me slightly, except it looks directly
// at DataMapContainer.all_entities in order to minimize code duplication. (Lol!)
// as such, entries, entry_colors and entries_are_instances are not used in here

var list = argument0;
var xx = argument1;
var yy = argument2;

var otext = list.text;

list.text = list.text + " (" + string(ds_list_size(list.root.event.types)) + ")";
ds_list_clear(list.entries);

// since these are just arrays and not instances we have to do this the hard way
for (var i = 0; i < ds_list_size(list.root.event.types); i++) {
    // don't alphabetize these
    var property = list.root.event.types[| i];
    ds_list_add(list.entries, property[EventNodeCustomData.NAME]);
}

ui_render_list(list, xx, yy);

list.text = otext;