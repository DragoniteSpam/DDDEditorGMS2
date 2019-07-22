/// @param UIList

var base_dialog = argument0.root;
var selection = ui_list_selection(base_dialog.el_list);

if (selection >= 0) {
    var sw_data = Stuff.switches[| selection];
    sw_data[@ 0] = base_dialog.el_name.value;

    base_dialog.el_list.entries[| selection] = sw_data[@ 0] + ": " + Stuff.tf[sw_data[@ 1]];
}