/// @param UIList
function uivc_animation_keyframe_graphic_sprite(argument0) {

    var list = argument0;
    var keyframe = list.root.root.root.root.el_timeline.selected_keyframe;
    var value = ui_list_selection(list);
    keyframe.graphic_sprite = value ? list.entries[| value] : 0;

    if (list == list.root.el_graphic_battler_sprite_list) {
        var sprite_overworld_index = ds_list_find_index(Stuff.all_graphic_overworlds, keyframe.graphic_sprite);
        ui_list_deselect(list.root.el_graphic_overworld_sprite_list);
        ui_list_select(list.root.el_graphic_overworld_sprite_list, sprite_overworld_index);
    }

    if (list == list.root.el_graphic_overworld_sprite_list) {
        var sprite_battler_index = ds_list_find_index(Stuff.all_graphic_battlers, keyframe.graphic_sprite);
        ui_list_deselect(list.root.el_graphic_battler_sprite_list);
        ui_list_select(list.root.el_graphic_battler_sprite_list, sprite_battler_index);
    }


}
