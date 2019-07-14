/// @param UIList

var selection = ui_list_selection(argument0);

if (selection >= 0) {
    var var_data = Stuff.all_global_variables[| selection];
    var base_dialog = argument0.root;

    base_dialog.el_name.value = var_data[0];
    base_dialog.el_default.value = string(var_data[1]);
}