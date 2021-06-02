function safc_on_entity_ui(entity) {
    // basic stuff
    ui_input_set_value(Stuff.map.ui.element_entity_name, entity.name);
    Stuff.map.ui.element_entity_type.text = "Type: " + object_get_name(entity.object_index);
    Stuff.map.ui.element_entity_static.value = entity.is_static;
    
    Stuff.map.ui.element_entity_name.interactive = true;
    //Stuff.map.ui.element_entity_collision_data.interactive = true;
    Stuff.map.ui.element_entity_static.interactive = true;
    Stuff.map.ui.element_entity_generic.interactive = true;
    
    Stuff.map.ui.element_entity_events.interactive = true;
    Stuff.map.ui.element_entity_event_add.interactive = true;
    Stuff.map.ui.element_entity_event_remove.interactive = true;
    Stuff.map.ui.element_entity_event_edit.interactive = true;
    
    if (array_empty(entity.object_events)) {
        // this has to be done manually since the list doesn't have an actual
        // list assigned to it (which it may be a good idea to change in the
        // future, but for now this will do)
        Stuff.map.ui.element_entity_events.index = 0;
        ds_map_add(Stuff.map.ui.element_entity_events.selected_entries, 0, true);
    }
    
    Stuff.map.ui.element_entity_option_direction_fix.value = entity.direction_fix;
    Stuff.map.ui.element_entity_option_always_update.value = entity.always_update;
    Stuff.map.ui.element_entity_option_preserve.value = entity.preserve_on_save;
    Stuff.map.ui.element_entity_option_reflect.value = entity.reflect;
    
    Stuff.map.ui.element_entity_option_direction_fix.interactive = true;
    Stuff.map.ui.element_entity_option_always_update.interactive = true;
    Stuff.map.ui.element_entity_option_autonomous_movement.interactive = true;
    Stuff.map.ui.element_entity_option_preserve.interactive = true;
    Stuff.map.ui.element_entity_option_reflect.interactive = true;
    
    // transform
    Stuff.map.ui.element_entity_pos_x.interactive = entity.translateable;
    Stuff.map.ui.element_entity_pos_y.interactive = entity.translateable;
    Stuff.map.ui.element_entity_pos_z.interactive = entity.translateable;
    Stuff.map.ui.element_entity_offset_x.interactive = entity.offsettable;
    Stuff.map.ui.element_entity_offset_y.interactive = entity.offsettable;
    Stuff.map.ui.element_entity_offset_z.interactive = entity.offsettable;
    Stuff.map.ui.element_entity_rot_x.interactive = entity.rotateable;
    Stuff.map.ui.element_entity_rot_y.interactive = entity.rotateable;
    Stuff.map.ui.element_entity_rot_z.interactive = entity.rotateable;
    Stuff.map.ui.element_entity_scale_x.interactive = entity.scalable;
    Stuff.map.ui.element_entity_scale_y.interactive = entity.scalable;
    Stuff.map.ui.element_entity_scale_z.interactive = entity.scalable;
    
    ui_input_set_value(Stuff.map.ui.element_entity_pos_x, string(entity.xx));
    ui_input_set_value(Stuff.map.ui.element_entity_pos_y, string(entity.yy));
    ui_input_set_value(Stuff.map.ui.element_entity_pos_z, string(entity.zz));
    ui_input_set_value(Stuff.map.ui.element_entity_offset_x, string(entity.off_xx));
    ui_input_set_value(Stuff.map.ui.element_entity_offset_y, string(entity.off_yy));
    ui_input_set_value(Stuff.map.ui.element_entity_offset_z, string(entity.off_zz));
    ui_input_set_value(Stuff.map.ui.element_entity_rot_x, string(entity.rot_xx));
    ui_input_set_value(Stuff.map.ui.element_entity_rot_y, string(entity.rot_yy));
    ui_input_set_value(Stuff.map.ui.element_entity_rot_z, string(entity.rot_zz));
    ui_input_set_value(Stuff.map.ui.element_entity_scale_x, string(entity.scale_xx));
    ui_input_set_value(Stuff.map.ui.element_entity_scale_y, string(entity.scale_yy));
    ui_input_set_value(Stuff.map.ui.element_entity_scale_z, string(entity.scale_zz));
}