/// @param UIColorPicker
function uivc_scribble_color_value(argument0) {

    var picker = argument0;
    var list = picker.root.el_list;
    var mode = Stuff.scribble;
    var selection = ui_list_selection(list);

    if (selection + 1) {
        global.__scribble_colours[? list.entries[| selection]] = picker.value;
        mode.scribble = noone;
        scribble_flush();
    }


}
