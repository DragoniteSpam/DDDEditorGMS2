/// @param UIInput
function uivc_event_attain_real(argument0) {

	var input = argument0;
	input.root.list[| input.root.index] = real(input.value);


}
