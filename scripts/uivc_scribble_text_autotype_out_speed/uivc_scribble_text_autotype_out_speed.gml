/// @param UIInput
function uivc_scribble_text_autotype_out_speed(argument0) {

	var input = argument0;
	var mode = Stuff.scribble;

	mode.scribble_autotype_out_speed = real(input.value);
	editor_scribble_autotype_fire();


}
