// could use selection_count() here but you may need to access
// element(s) of the list so that won't work

var list = selection_all();
ds_list_destroy(Camera.selected_entities);
Camera.selected_entities = list;

if (ds_list_size(list) == 0) {
    // deactivate everything
    Camera.ui.element_entity_name.interactive = false;
    Camera.ui.element_entity_solid.interactive = false;
    Camera.ui.element_entity_static.interactive = false;
    Camera.ui.element_entity_events.interactive = false;
    Camera.ui.element_entity_event_add.interactive = false;
    Camera.ui.element_entity_event_remove.interactive = false;
    Camera.ui.element_entity_event_edit.interactive = false;
    
    Camera.ui.element_entity_option_animate_idle.interactive = false;
    Camera.ui.element_entity_option_animate_movement.interactive = false;
    Camera.ui.element_entity_option_direction_fix.interactive = false;
    Camera.ui.element_entity_option_reset_position.interactive = false;
    Camera.ui.element_entity_option_autonomous_movement.interactive = false;
    
    ui_list_deselect(Camera.ui.element_entity_events);
    
    // transform
    
    Camera.ui.element_entity_pos_x.interactive = false;
    Camera.ui.element_entity_pos_y.interactive = false;
    Camera.ui.element_entity_pos_z.interactive = false;
    Camera.ui.element_entity_offset_x.interactive = false;
    Camera.ui.element_entity_offset_y.interactive = false;
    Camera.ui.element_entity_offset_z.interactive = false;
    Camera.ui.element_entity_rot_x.interactive = false;
    Camera.ui.element_entity_rot_y.interactive = false;
    Camera.ui.element_entity_rot_z.interactive = false;
    Camera.ui.element_entity_scale_x.interactive = false;
    Camera.ui.element_entity_scale_y.interactive = false;
    Camera.ui.element_entity_scale_z.interactive = false;
    
    // entity-mesh
    
    Camera.ui.element_entity_mesh_animated.value = false;
    Camera.ui.element_entity_mesh_animated.interactive = false;
    
    // entity-pawn
    
    ui_input_set_value(Camera.ui.element_entity_pawn_frame, "0");
    Camera.ui.element_entity_pawn_frame.interactive = false;
    Camera.ui.element_entity_pawn_direction.value = 0;
    Camera.ui.element_entity_pawn_direction.interactive = false;
    Camera.ui.element_entity_pawn_animating.value = false;
    Camera.ui.element_entity_pawn_animating.interactive = false;
} else if (ds_list_size(list) == 1) {
    safa_on_select(list[| 0]);
} else {
    // populate the UI elements with a nice ¯\_(ツ)_/¯
    ui_input_set_value(Camera.ui.element_entity_name, "");
    Camera.ui.element_entity_solid.value = 2;
    Camera.ui.element_entity_static.value = 2;
    
    ui_list_deselect(Camera.ui.element_entity_events);
    
    Camera.ui.element_entity_name.interactive = true;
    Camera.ui.element_entity_solid.interactive = true;
    Camera.ui.element_entity_static.interactive = true;
    
    Camera.ui.element_entity_events.interactive = false;
    Camera.ui.element_entity_event_add.interactive = false;
    Camera.ui.element_entity_event_remove.interactive = false;
    Camera.ui.element_entity_event_edit.interactive = false;
    
    Camera.ui.element_entity_option_animate_idle.value = 2;
    Camera.ui.element_entity_option_animate_movement.value = 2;
    Camera.ui.element_entity_option_direction_fix.value = 2;
    Camera.ui.element_entity_option_reset_position.value = 2;
    
    Camera.ui.element_entity_option_animate_idle.interactive = true;
    Camera.ui.element_entity_option_animate_movement.interactive = true;
    Camera.ui.element_entity_option_direction_fix.interactive = true;
    Camera.ui.element_entity_option_reset_position.interactive = true;
    Camera.ui.element_entity_option_autonomous_movement.interactive = false;
    
    // transform - position is disabled when multiple entities are selected because
    // you do NOT want to pile everything into the same cell
    
    // not all of these things may be valid for the type of selected entities, but
    // we'll pretend that they are. the onvaluechange should check to see if you're
    // allowed to do the operation also, anyway.
    
    Camera.ui.element_entity_pos_x.interactive = false;
    Camera.ui.element_entity_pos_y.interactive = false;
    Camera.ui.element_entity_pos_z.interactive = false;
    Camera.ui.element_entity_offset_x.interactive = true;
    Camera.ui.element_entity_offset_y.interactive = true;
    Camera.ui.element_entity_offset_z.interactive = true;
    Camera.ui.element_entity_rot_x.interactive = true;
    Camera.ui.element_entity_rot_y.interactive = true;
    Camera.ui.element_entity_rot_z.interactive = true;
    Camera.ui.element_entity_scale_x.interactive = true;
    Camera.ui.element_entity_scale_y.interactive = true;
    Camera.ui.element_entity_scale_z.interactive = true;
    
    ui_input_set_value(Camera.ui.element_entity_pos_x, "");
    ui_input_set_value(Camera.ui.element_entity_pos_y, "");
    ui_input_set_value(Camera.ui.element_entity_pos_z, "");
    ui_input_set_value(Camera.ui.element_entity_offset_x, "");
    ui_input_set_value(Camera.ui.element_entity_offset_y, "");
    ui_input_set_value(Camera.ui.element_entity_offset_z, "");
    ui_input_set_value(Camera.ui.element_entity_rot_x, "");
    ui_input_set_value(Camera.ui.element_entity_rot_y, "");
    ui_input_set_value(Camera.ui.element_entity_rot_z, "");
    ui_input_set_value(Camera.ui.element_entity_scale_x, "");
    ui_input_set_value(Camera.ui.element_entity_scale_y, "");
    ui_input_set_value(Camera.ui.element_entity_scale_z, "");
    
    var type = selection_all_type();
    
    switch (type) {
        case EntityAutoTile:
            // fallthrough
        case EntityTile:
            break;
        case EntityMeshTerrain:
            // fallthrough
        case EntityMesh:
            Camera.ui.element_entity_mesh_animated.value = 2;
            
            Camera.ui.element_entity_mesh_animated.interactive = true;
            break;
        case EntityPawn:
            Camera.ui.element_entity_pawn_frame.value = "0";
            Camera.ui.element_entity_pawn_direction.value = 0;
            Camera.ui.element_entity_pawn_animating.value = 2;
            
            Camera.ui.element_entity_pawn_frame.interactive = true;
            Camera.ui.element_entity_pawn_direction.interactive = true;
            Camera.ui.element_entity_pawn_animating.interactive = true;
            break;
        case EntityEffect:
            break;
    }
}

var terrain = selected_affected_terrain();

for (var i = 0; i < ds_list_size(terrain); i++) {
    var thing = terrain[| i];
    thing.terrain_id = get_autotile_id(thing);
    
    //terrain[| i].mesh_id = 
    if (!ds_map_exists(Stuff.autotile_map, thing.terrain_id)) {
        thing.terrain_id = 255;
    }
    
    var mapping = Stuff.autotile_map[? thing.terrain_id];
    thing.mesh_data = Stuff.active_map.contents.mesh_autotiles[mapping];
    thing.mesh_data_raw = Stuff.active_map.contents.mesh_autotile_raw[mapping];
}

ds_list_destroy(terrain);