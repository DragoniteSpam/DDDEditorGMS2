/// @param UIThing

var button = argument0;
var list = button.root.el_list;
var selection = ui_list_selection(list);

if (selection + 1) {
    var what = list.entries[| selection];
    sprite_save(what.picture, 0, what.name + ".png");
    ds_stuff_open_local(what.name + ".png");
}