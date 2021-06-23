function safc_fill_zone() {
    // not technically a Selection Fill script, but it's used in a similar way
    var button = Stuff.map.ui.t_p_other.el_zone_data;
    
    for (var i = 0; i < array_length(Stuff.map.selection); i++) {
        var selection = Stuff.map.selection[i];
        // Only going to do this with rectangle zones. I'm not currently planning on
        // supporting spherical zones, and size-one zones are kinda pointless.
        if (instanceof(selection) == "SelectionRectangle") {
            var zone_list = Stuff.map.ui.t_p_other_editor.el_zone_type;
            var type = global.map_zone_type_objects[ui_list_selection(zone_list)];
            var zone = instance_create_depth(0, 0, 0, type);
            instance_deactivate_object(zone);
            zone.name = object_get_name(type) + " " + string(ds_list_size(Stuff.map.active_map.contents.all_zones));
            
            zone.x1 = selection.x;
            zone.y1 = selection.y;
            zone.z1 = selection.z;
            zone.x2 = selection.x2;
            zone.y2 = selection.y2;
            zone.z2 = selection.z2;
            
            map_zone_collision(zone);
            
            button.interactive = true;
            button.onmouseup = zone.zone_edit_script;
            button.text = "Data: " + zone.name;
            Stuff.map.selected_zone = zone;
        }
    }
    
    selection_clear();
    
    if (!Settings.view.zones) {
        emu_dialog_notice("Zones are currently set to be invisible. It is recommended that you turn on Zone Visibility in the General tab.");
    }
}