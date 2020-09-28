/// @param UIList
/// @param index
function ui_list_colors_data_types(argument0, argument1) {

    var list = argument0;
    var index = argument1;

    return instanceof_classic(list.entries[| index], DataEnum) ? c_blue : c_black;


}
