/// @param UIRadioArrayOption
function uivc_scribble_text_autotype_in_method(argument0) {

	var radio = argument0;
	var mode = Stuff.scribble;

	mode.scribble_autotype_in_method = radio.value;
	editor_scribble_autotype_fire();


}
