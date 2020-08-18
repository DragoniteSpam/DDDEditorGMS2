/// @param UIRadioArray
/// @param [strings]
function create_radio_array_options(argument0, argument1) {

	var array = argument0;
	var strings = argument1;

	for (var i = 0; i < array_length_1d(strings); i++) {
	    var option = instance_create_depth(0, array.height * (1 + i), 0, UITextRadio);
	    option.text = strings[i];
	    option.root = array;
	    option.height = array.height;
	    option.value = i;
	    option.adjust_view = array.adjust_view;
    
	    ds_list_add(array.contents, option);
	}


}
