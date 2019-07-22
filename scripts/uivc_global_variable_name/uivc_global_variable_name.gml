/// @param UIList

var base_dialog = argument0.root;
var selection = ui_list_selection(base_dialog.el_list);

if (selection >= 0) {
    var var_data = Stuff.variables[| selection];

    var_data[@ 0] = base_dialog.el_name.value;
    base_dialog.el_list.entries[| selection] = var_data[@ 0] + ": " + string(var_data[@ 1]);
}