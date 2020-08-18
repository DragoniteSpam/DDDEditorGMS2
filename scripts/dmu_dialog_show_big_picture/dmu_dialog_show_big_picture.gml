/// @param UIButton
function dmu_dialog_show_big_picture(argument0) {

	var button = argument0;

	if (button.image) {
	    dialog_create_big_picture(button, button.image);
	}


}
