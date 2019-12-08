/// @param UIButton

var button = argument0;
var selection = ui_list_selection(button.root.el_list);

if (selection + 1) {
    var what = Stuff.all_bgm[| selection];
    audio_set_sample_rate(what, 44100);
    ui_input_set_value(button.root.el_sample_rate, string(what.fmod_rate));
}