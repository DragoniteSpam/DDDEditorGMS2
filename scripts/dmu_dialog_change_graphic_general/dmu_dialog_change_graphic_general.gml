/// @param UIThing

var button = argument0;
var list = button.root.el_list;
var selection = ui_list_selection(list);

if (selection + 1) {
    var fn = get_open_filename("Image files (*.png)|*.png", "");
    if (file_exists(fn)) {
        var what = list.entries[| selection];
        sprite_delete(what.picture);
        what.picture = sprite_add(fn, 0, false, false, 0, 0);
        uivc_list_graphic_generic(list);
    }
}