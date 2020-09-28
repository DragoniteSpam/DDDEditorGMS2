/// @param UIButton
function uivc_input_graphic_set_dim_full(argument0) {

    var button = argument0;
    var list = button.root.el_list;
    var selection = ui_list_selection(list);

    if (selection + 1) {
        var data = list.entries[| selection];
        data.width = sprite_get_width(data.picture); 
        data.height = sprite_get_height(data.picture); 
        list.root.el_dim_x.value = string(data.width);
        list.root.el_dim_y.value = string(data.height);
    
        data_image_npc_frames(data);
    }


}
