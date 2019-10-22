/// @param UIList

var selection = ui_list_selection(argument0);
var base_dialog = argument0.root;

if (selection + 1) {
    var what = Stuff.all_game_constants[| selection];
    ui_input_set_value(base_dialog.el_name, what.name);
    base_dialog.el_type.interactive = true;
    base_dialog.el_type.value = what.type;
    base_dialog.el_type_ext.interactive = true;
    
    ui_constant_data_activate(base_dialog, what.type);
}