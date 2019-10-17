/// @param UIList

var list = argument0;
var selection = ui_list_selection(list);

if (selection >= 0) {
    var what = Stuff.all_graphic_etc[| selection];
    
    list.root.el_name.value = what.name;
    list.root.el_name_internal.value = what.internal_name;
}