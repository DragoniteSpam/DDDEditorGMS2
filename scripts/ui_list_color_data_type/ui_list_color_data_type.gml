/// @param UIList
/// @param index
function ui_list_color_data_type(argument0, argument1) {

    var list = argument0;
    var index = argument1;

    var type = list.entries[| index];

    if (instanceof_classic(type, DataEnum)) {
        return c_blue;
    }

    if (instanceof_classic(type, DataData)) {
        return c_black;
    }


}
