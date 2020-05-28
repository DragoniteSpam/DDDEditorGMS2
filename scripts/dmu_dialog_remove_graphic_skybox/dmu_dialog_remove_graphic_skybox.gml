/// @param UIThing

var button = argument0;
var list = button.root.el_list;
var selection = ui_list_selection(list);
ui_list_deselect(button.root.el_list);

if (selection + 1) {
    graphics_remove_skybox(list.entries[| selection].GUID);
    ui_list_deselect(button.root.el_list);
    list.root.el_image.image = -1;
}