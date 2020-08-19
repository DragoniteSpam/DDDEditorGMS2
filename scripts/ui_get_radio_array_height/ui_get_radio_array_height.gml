/// @param UIRadioArray
function ui_get_radio_array_height(argument0) {

    var array = argument0;

    return array.height * (1 + ds_list_size(array.contents));


}
