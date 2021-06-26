function safc_fill_zone() {
    // not technically a Selection Fill script, but it's used in a similar way
    var button = Stuff.map.ui.t_p_other.el_zone_data;
    
    for (var i = 0; i < array_length(Stuff.map.selection); i++) {
        var selection = Stuff.map.selection[i];
        // Only going to do this with rectangle zones. I'm not currently planning on
        // supporting spherical zones, and size-one zones are kinda pointless.
        if (instanceof(selection) == "SelectionRectangle") {
            var zone_list = Stuff.map.ui.t_p_other_editor.el_zone_type;
            var zone = new global.map_zone_type_objects[ui_list_selection(zone_list)](selection.x, selection.y, selection.z, selection.x2, selection.y2, selection.z2);
            zone.name = instanceof(zone) + " " + string(array_length(Stuff.map.active_map.contents.all_zones));
            array_push(Stuff.map.active_map.contents.all_zones, zone);
            
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