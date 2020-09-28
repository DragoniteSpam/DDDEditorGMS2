/// @param UIList
/// @param index
function ui_list_colors_image_exclude(argument0, argument1) {

    var list = argument0;
    var index = argument1;

    return list.entries[| index].texture_exclude ? c_dkgray : c_black;


}
