/// @param UIColorPicker
function uivc_scribble_default_colour(argument0) {

	var picker = argument0;
	var mode = Stuff.scribble;

	// the actual color is updated in the scribble render script, since you
	// don't want this to affect text drawn in other places
	mode.scribble = noone;
	scribble_flush();


}
