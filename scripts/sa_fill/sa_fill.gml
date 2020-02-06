if (Stuff.setting_selection_fill_type == FillTypes.CAMERA_ZONE) {
    for (var i = 0; i < ds_list_size(Stuff.map.selection); i++) {
        var selection = Stuff.map.selection[| i];
        if (instanceof(selection, SelectionRectangle)) {
            var zone = instance_create_depth(0, 0, 0, DataCameraZone);
            instance_deactivate_object(zone);
            zone.x1 = selection.x;
            zone.y1 = selection.y;
            zone.z1 = selection.z;
            zone.x2 = selection.x2;
            zone.y2 = selection.y2;
            zone.z2 = selection.z2;
        }
    }
    
    selection_clear();
    return 0;
}

sa_foreach_cell(Stuff.map.fill_types[Stuff.setting_selection_fill_type], noone);
selection_update_autotiles();
sa_process_selection();