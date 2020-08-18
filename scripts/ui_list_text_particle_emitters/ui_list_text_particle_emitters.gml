/// @param UIList
/// @param index
function ui_list_text_particle_emitters(argument0, argument1) {

	var list = argument0;
	var index = argument1;
	var emitter = list.entries[| index];

	var text = emitter.name;

	if (!emitter.streaming) {
	    text = "(" + text + ")";
	}

	return text;


}
