/// @param UIList
function uivc_list_event_attain_map_index(argument0) {

    var list = argument0;

    if (Stuff.event.map != Stuff.all_maps[| ui_list_selection(list)]) {
        var visible_map = Stuff.all_maps[| ui_list_selection(list)];
    
        if (Stuff.event.map) {
            if (Stuff.event.map.preview) {
                vertex_delete_buffer(Stuff.event.map.preview);
                Stuff.event.map.preview = noone;
            }
            if (Stuff.event.map.wpreview) {
                vertex_delete_buffer(Stuff.event.map.wpreview);
                Stuff.event.map.wpreview = noone;
            }
            if (Stuff.event.map.cpreview) {
                c_world_remove_object(Stuff.event.map.cpreview);
                Stuff.event.map.cpreview = noone;
            }
            if (Stuff.event.map.cpreview) {
                c_object_destroy(Stuff.event.map.cpreview);
                Stuff.event.map.cpreview = noone;
            }
            if (Stuff.event.map.cspreview) {
                c_shape_destroy(Stuff.event.map.cspreview);
                Stuff.event.map.cspreview = noone;
            }
        }
    
        list.root.node.custom_data[0][0] = visible_map.GUID;
    
        if (visible_map.preview) {
            vertex_delete_buffer(visible_map.preview);
            vertex_delete_buffer(visible_map.wpreview);
        }
    
        batch_all_preview(visible_map);
    
        Stuff.event.map = visible_map;
    }


}
