/// @param UIInput
function uivc_input_audio_bgm_internal_name(argument0) {

    var input = argument0;
    var selection = ui_list_selection(input.root.el_list);

    if (selection + 1) {
        var already = internal_name_get(input.value);
        if (!already || already == Stuff.all_bgm[| selection]) {
            internal_name_remove(Stuff.all_bgm[| selection].internal_name);
            internal_name_set(Stuff.all_bgm[| selection], input.value);
            input.color = c_black;
        } else {
            input.color = c_red;
        }
    }


}
