/// @param UIInput

var input = argument0;
var list = input.root.el_list;
var selection = ui_list_selection(list);

if (selection + 1) {
    uivc_input_graphic_set_frames_h(input);
    data_image_npc_frames(list.entries[| selection]);
}