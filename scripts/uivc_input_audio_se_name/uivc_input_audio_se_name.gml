/// @param UIInput
function uivc_input_audio_se_name(argument0) {

    var input = argument0;
    var selection = ui_list_selection(input.root.el_list);

    if (selection + 1) {
        Stuff.all_se[| selection].name = input.value;
    }


}
