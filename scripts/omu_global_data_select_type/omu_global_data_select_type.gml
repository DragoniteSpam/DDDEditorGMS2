/// @param UIButton
function omu_global_data_select_type(argument0) {

    var button = argument0;
    var selection = ui_list_selection(button.root.el_list);
    var constant = Stuff.all_game_constants[| selection];

    var dialog = dialog_create_select_data_types_ext(button, constant.type, uivc_input_constant_type_ext);
    dialog.constant = constant;
    dialog.el_list.contents[| DataTypes.ENTITY].interactive = false;
    dialog.el_list.contents[| DataTypes.TILE].interactive = false;


}
