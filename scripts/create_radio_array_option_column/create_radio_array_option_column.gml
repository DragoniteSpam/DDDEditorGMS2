/// @param UIRadioArray
/// @param from-index
/// @param new-col-x
function create_radio_array_option_column() {

	var array = argument[0];
	var index = argument[1];
	var xx = argument[2] - array.x;

	for (var i = index; i < ds_list_size(array.contents); i++) {
	    var option = array.contents[| i];
	    option.x = xx;
	    option.y = array.height * (1 + i - index);
	}


}
