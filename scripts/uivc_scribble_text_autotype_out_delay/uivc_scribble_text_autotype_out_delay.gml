/// @param UIInput
function uivc_scribble_text_autotype_out_delay(argument0) {

	var input = argument0;
	var mode = Stuff.scribble;

	mode.scribble_autotype_out_delay = real(input.value);
	editor_scribble_autotype_fire();


}
