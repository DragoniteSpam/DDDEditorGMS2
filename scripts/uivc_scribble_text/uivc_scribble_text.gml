/// @param UIInput
function uivc_scribble_text(argument0) {

	var input = argument0;
	var mode = Stuff.scribble;

	mode.scribble_text = input.value;
	mode.scribble_text_time = current_time;


}
