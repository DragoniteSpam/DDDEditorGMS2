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
            var ww = zone.x2 - zone.x1;
            var hh = zone.y2 - zone.y1;
            var dd = zone.z2 - zone.z1;
            
            zone.zz = zone.z1;
            
            zone.cshape = c_shape_create();
            c_shape_add_box(zone.cshape, ww * TILE_WIDTH / 2, hh * TILE_HEIGHT / 2, dd * TILE_DEPTH / 2);
            zone.cobject = c_object_create(zone.cshape, CollisionMasks.MAIN, CollisionMasks.MAIN);
            
            c_transform_position((zone.x1 + ww / 2) * TILE_WIDTH, (zone.y1 + hh / 2) * TILE_HEIGHT, (zone.z1 + dd / 2) * TILE_DEPTH);
            c_object_apply_transform(zone.cobject);
            c_transform_identity();
            
            c_world_add_object(zone.cobject);
            c_object_set_userid(zone.cobject, zone);
        }
    }
    
    selection_clear();
    return 0;
}

sa_foreach_cell(Stuff.map.fill_types[Stuff.setting_selection_fill_type], noone);
selection_update_autotiles();
sa_process_selection();