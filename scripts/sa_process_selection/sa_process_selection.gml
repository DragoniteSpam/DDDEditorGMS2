// could use selection_count() here but you may need to access
// element(s) of the list so that won't work

var list = selection_all();
var map = Stuff.map.active_map;
ds_list_destroy(Stuff.map.selected_entities);
Stuff.map.selected_entities = list;

if (ds_list_size(list) == 0) {
    // type
    Stuff.map.ui.element_entity_type.text = "Type:";
    // deactivate everything
    Stuff.map.ui.element_entity_name.interactive = false;
    //Stuff.map.ui.element_entity_collision_data.interactive = false;
    Stuff.map.ui.element_entity_static.interactive = false;
    Stuff.map.ui.element_entity_generic.interactive = false;
    
    Stuff.map.ui.element_entity_events.interactive = false;
    Stuff.map.ui.element_entity_event_add.interactive = false;
    Stuff.map.ui.element_entity_event_remove.interactive = false;
    Stuff.map.ui.element_entity_event_edit.interactive = false;
    
    ui_list_deselect(Stuff.map.ui.element_entity_events);
    
    Stuff.map.ui.element_entity_option_animate_idle.interactive = false;
    Stuff.map.ui.element_entity_option_animate_movement.interactive = false;
    Stuff.map.ui.element_entity_option_direction_fix.interactive = false;
    Stuff.map.ui.element_entity_option_reset_position.interactive = false;
    Stuff.map.ui.element_entity_option_autonomous_movement.interactive = false;
    
    ui_list_deselect(Stuff.map.ui.element_entity_events);
    Stuff.map.ui.element_entity_events.entries = noone;
    
    // transform
    
    Stuff.map.ui.element_entity_pos_x.interactive = false;
    Stuff.map.ui.element_entity_pos_y.interactive = false;
    Stuff.map.ui.element_entity_pos_z.interactive = false;
    Stuff.map.ui.element_entity_offset_x.interactive = false;
    Stuff.map.ui.element_entity_offset_y.interactive = false;
    Stuff.map.ui.element_entity_offset_z.interactive = false;
    Stuff.map.ui.element_entity_rot_x.interactive = false;
    Stuff.map.ui.element_entity_rot_y.interactive = false;
    Stuff.map.ui.element_entity_rot_z.interactive = false;
    Stuff.map.ui.element_entity_scale_x.interactive = false;
    Stuff.map.ui.element_entity_scale_y.interactive = false;
    Stuff.map.ui.element_entity_scale_z.interactive = false;
    
    // entity-mesh
    
    Stuff.map.ui.element_entity_mesh_animated.value = false;
    Stuff.map.ui.element_entity_mesh_animated.interactive = false;
    
    // entity-pawn
    
    ui_input_set_value(Stuff.map.ui.element_entity_pawn_frame, "0");
    Stuff.map.ui.element_entity_pawn_frame.interactive = false;
    Stuff.map.ui.element_entity_pawn_direction.value = 0;
    Stuff.map.ui.element_entity_pawn_direction.interactive = false;
    Stuff.map.ui.element_entity_pawn_animating.value = false;
    Stuff.map.ui.element_entity_pawn_animating.interactive = false;
    Stuff.map.ui.element_entity_pawn_sprite.interactive = false;
    ui_list_deselect(Stuff.map.ui.element_entity_pawn_sprite);
} else if (ds_list_size(list) == 1) {
    safa_on_select(list[| 0]);
} else {
    // if multiple eligible entities are selected, populate the UI
    // elements with a nice ¯\_(ツ)_/¯
    ui_input_set_value(Stuff.map.ui.element_entity_name, "");
    Stuff.map.ui.element_entity_static.value = 2;
    
    ui_list_deselect(Stuff.map.ui.element_entity_events);
    
    Stuff.map.ui.element_entity_name.interactive = true;
    //Stuff.map.ui.element_entity_collision_data.interactive = true;
    Stuff.map.ui.element_entity_generic.interactive = true;
    Stuff.map.ui.element_entity_static.interactive = true;
    
    Stuff.map.ui.element_entity_events.interactive = false;
    Stuff.map.ui.element_entity_event_add.interactive = false;
    Stuff.map.ui.element_entity_event_remove.interactive = false;
    Stuff.map.ui.element_entity_event_edit.interactive = false;
    
    Stuff.map.ui.element_entity_option_animate_idle.value = 2;
    Stuff.map.ui.element_entity_option_animate_movement.value = 2;
    Stuff.map.ui.element_entity_option_direction_fix.value = 2;
    Stuff.map.ui.element_entity_option_reset_position.value = 2;
    
    Stuff.map.ui.element_entity_option_animate_idle.interactive = true;
    Stuff.map.ui.element_entity_option_animate_movement.interactive = true;
    Stuff.map.ui.element_entity_option_direction_fix.interactive = true;
    Stuff.map.ui.element_entity_option_reset_position.interactive = true;
    Stuff.map.ui.element_entity_option_autonomous_movement.interactive = false;
    
    // transform - position is disabled when multiple entities are selected because
    // you do NOT want to pile everything into the same cell
    
    // not all of these things may be valid for the type of selected entities, but
    // we'll pretend that they are. the onvaluechange should check to see if you're
    // allowed to do the operation also, anyway.
    
    Stuff.map.ui.element_entity_pos_x.interactive = false;
    Stuff.map.ui.element_entity_pos_y.interactive = false;
    Stuff.map.ui.element_entity_pos_z.interactive = false;
    Stuff.map.ui.element_entity_offset_x.interactive = true;
    Stuff.map.ui.element_entity_offset_y.interactive = true;
    Stuff.map.ui.element_entity_offset_z.interactive = true;
    Stuff.map.ui.element_entity_rot_x.interactive = true;
    Stuff.map.ui.element_entity_rot_y.interactive = true;
    Stuff.map.ui.element_entity_rot_z.interactive = true;
    Stuff.map.ui.element_entity_scale_x.interactive = true;
    Stuff.map.ui.element_entity_scale_y.interactive = true;
    Stuff.map.ui.element_entity_scale_z.interactive = true;
    
    ui_input_set_value(Stuff.map.ui.element_entity_pos_x, "");
    ui_input_set_value(Stuff.map.ui.element_entity_pos_y, "");
    ui_input_set_value(Stuff.map.ui.element_entity_pos_z, "");
    ui_input_set_value(Stuff.map.ui.element_entity_offset_x, "");
    ui_input_set_value(Stuff.map.ui.element_entity_offset_y, "");
    ui_input_set_value(Stuff.map.ui.element_entity_offset_z, "");
    ui_input_set_value(Stuff.map.ui.element_entity_rot_x, "");
    ui_input_set_value(Stuff.map.ui.element_entity_rot_y, "");
    ui_input_set_value(Stuff.map.ui.element_entity_rot_z, "");
    ui_input_set_value(Stuff.map.ui.element_entity_scale_x, "");
    ui_input_set_value(Stuff.map.ui.element_entity_scale_y, "");
    ui_input_set_value(Stuff.map.ui.element_entity_scale_z, "");
    
    var type = selection_all_type();
    
    Stuff.map.ui.element_entity_type.text = "Type: " + object_get_name(type);
    
    switch (type) {
        case EntityAutoTile:
        case EntityTile:
            break;
        case EntityMeshAutotile:
        case EntityMesh:
            Stuff.map.ui.element_entity_mesh_animated.value = 2;
            
            Stuff.map.ui.element_entity_mesh_animated.interactive = true;
            break;
        case EntityPawn:
            Stuff.map.ui.element_entity_pawn_frame.value = "0";
            Stuff.map.ui.element_entity_pawn_direction.value = 0;
            Stuff.map.ui.element_entity_pawn_animating.value = 2;
            ui_list_deselect(Stuff.map.ui.element_entity_pawn_sprite);
            
            Stuff.map.ui.element_entity_pawn_frame.interactive = true;
            Stuff.map.ui.element_entity_pawn_direction.interactive = true;
            Stuff.map.ui.element_entity_pawn_animating.interactive = true;
            Stuff.map.ui.element_entity_pawn_sprite.interactive = true;
            break;
        case EntityEffect:
            break;
    }
}