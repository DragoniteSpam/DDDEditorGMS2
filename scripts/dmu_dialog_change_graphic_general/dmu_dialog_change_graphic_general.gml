/// @param UIThing

var button = argument0;
var list = button.root.el_list;
var selection = ui_list_selection(list);

if (selection + 1) {
    var fn = get_open_filename_image();
    if (file_exists(fn)) {
        var data = list.entries[| selection];
        var remove_back = !keyboard_check_direct(vk_control);
        sprite_delete(data.picture);
        data.picture = sprite_add(fn, 0, remove_back, false, 0, 0);
        uivc_list_graphic_generic(list);
        
        data_image_force_power_two(data);
        data_image_npc_frames(data);
    }
}