/// @param UIList

var list = argument0;
var type = list.root.type;
var selection = ui_list_selection(list);

if (selection + 1) {
    type.sprite = Stuff.all_graphic_particles[| selection];
}