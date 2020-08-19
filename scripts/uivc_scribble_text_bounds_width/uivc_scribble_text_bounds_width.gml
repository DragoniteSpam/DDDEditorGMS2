/// @param UIProgressBar
function uivc_scribble_text_bounds_width(argument0) {

    var bar = argument0;
    var mode = Stuff.scribble;

    mode.scribble_bounds_width = bar.value;
    mode.scribble = noone;
    scribble_flush();


}
