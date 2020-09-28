/// @param UIInput
function uivc_scribble_text_autotype_in_speed(argument0) {

    var input = argument0;
    var mode = Stuff.scribble;

    mode.scribble_autotype_in_speed = real(input.value);
    editor_scribble_autotype_fire();


}
