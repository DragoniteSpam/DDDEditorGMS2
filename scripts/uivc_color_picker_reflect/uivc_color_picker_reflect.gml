/// @param UIColorPickerInput
function uivc_color_picker_reflect(argument0) {

    var picker = argument0;
    var base_picker = picker.root.root;

    base_picker.value = picker.value;
    base_picker.alpha = picker.alpha;
    script_execute(base_picker.onvaluechange, base_picker);


}
