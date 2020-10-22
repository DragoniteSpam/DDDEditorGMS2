function uivc_color_picker_reflect(picker) {
    var base_picker = picker.root.root;
    base_picker.value = picker.value;
    base_picker.alpha = picker.alpha;
    base_picker.onvaluechange(base_picker);
}