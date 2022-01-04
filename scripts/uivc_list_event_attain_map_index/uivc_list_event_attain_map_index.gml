function uivc_list_event_attain_map_index(list) {
    if (Stuff.event.map != Game.maps[ui_list_selection(list)]) {
        var visible_map = Game.maps[ui_list_selection(list)];
        
        if (Stuff.event.map) {
            if (Stuff.event.map.preview) {
                vertex_delete_buffer(Stuff.event.map.preview);
                Stuff.event.map.preview = noone;
            }
            if (Stuff.event.map.wpreview) {
                vertex_delete_buffer(Stuff.event.map.wpreview);
                Stuff.event.map.wpreview = noone;
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