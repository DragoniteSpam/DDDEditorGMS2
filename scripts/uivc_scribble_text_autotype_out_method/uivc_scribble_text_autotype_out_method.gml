/// @param UIRadioArrayOption
function uivc_scribble_text_autotype_out_method(argument0) {

    var radio = argument0;
    var mode = Stuff.scribble;

    mode.scribble_autotype_out_method = radio.value;
    editor_scribble_autotype_fire();


}
