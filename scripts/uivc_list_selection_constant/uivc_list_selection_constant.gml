/// @param UIList
function uivc_list_selection_constant(argument0) {

    var list = argument0;
    var selection = ui_list_selection(list);
    var base_dialog = list.root;

    if (selection + 1) {
        var what = Stuff.all_game_constants[| selection];
        ui_input_set_value(base_dialog.el_name, what.name);
        base_dialog.el_type.interactive = true;
        base_dialog.el_type.value = what.type;
        base_dialog.el_type_ext.interactive = true;
    
        ui_constant_data_activate(base_dialog, what);
    }


}
