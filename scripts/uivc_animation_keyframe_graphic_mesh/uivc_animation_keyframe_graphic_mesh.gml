/// @param UIList
function uivc_animation_keyframe_graphic_mesh(argument0) {

    var list = argument0;
    var keyframe = list.root.root.root.root.el_timeline.selected_keyframe;
    var value = ui_list_selection(list);
    keyframe.graphic_mesh = value ? list.entries[| value] : 0;


}
