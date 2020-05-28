/// @param UIList

var list = argument0;
var selection = ui_list_selection(list);

if (selection + 1) {
    list.root.map.skybox = Stuff.all_graphic_skybox[| selection];
} else {
    list.root.map.skybox = noone;
}