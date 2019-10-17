/// @param UIButton

var button = argument0;
var selection = ui_list_selection(button.root.el_list);
ui_list_deselect(button.root.el_list);

if (selection + 1) {
    graphics_remove_ui(Stuff.all_graphic_ui[| selection].GUID);
    ui_list_deselect(button.root.el_list);
}