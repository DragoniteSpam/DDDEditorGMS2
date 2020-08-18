/// @param UIInput
function uivc_scribble_text_autotype_in_delay(argument0) {

	var input = argument0;
	var mode = Stuff.scribble;

	mode.scribble_autotype_in_delay = real(input.value);
	editor_scribble_autotype_fire();


}
