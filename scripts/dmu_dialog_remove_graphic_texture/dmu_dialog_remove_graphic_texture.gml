/// @param UIThing

var button = argument0;
var list = button.root.el_list;
var selection = ui_list_selection(list);
ui_list_deselect(button.root.el_list);

if (selection + 1) {
    var data = list.entries[| selection];
    ds_list_delete(Stuff.all_graphic_tilesets, ds_list_find_index(Stuff.all_graphic_tilesets, data));
    instance_activate_object(data);
    instance_destroy(data);
    ui_list_deselect(button.root.el_list);
    list.root.el_image.image = -1;
}