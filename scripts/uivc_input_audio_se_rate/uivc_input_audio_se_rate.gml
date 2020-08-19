/// @param UIInput
function uivc_input_audio_se_rate(argument0) {

    var input = argument0;
    var selection = ui_list_selection(input.root.el_list);

    if (selection + 1) {
        audio_set_sample_rate(Stuff.all_se[| selection], real(input.value));
    }


}
