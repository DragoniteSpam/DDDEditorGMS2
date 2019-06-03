/// @description void sa_process_selection();
// could use selection_count() here but you may need to access
// element(s) of the list so that won't work

var list=selection_all();
ds_list_destroy(Camera.selected_entities);
Camera.selected_entities=list;

if (ds_list_size(list)==0) {
    // deactivate everything
    Camera.ui.element_entity_name.interactive=false;
    Camera.ui.element_entity_solid.interactive=false;
    Camera.ui.element_entity_static.interactive=false;
    Camera.ui.element_entity_events.interactive=false;
    Camera.ui.element_entity_event_add.interactive=false;
    Camera.ui.element_entity_event_remove.interactive=false;
    Camera.ui.element_entity_event_edit.interactive=false;
    
    Camera.ui.element_entity_option_animate_idle.interactive=false;
    Camera.ui.element_entity_option_animate_movement.interactive=false;
    Camera.ui.element_entity_option_direction_fix.interactive=false;
    Camera.ui.element_entity_autonomous_movement.interactive=false;
    
    ds_map_clear(Camera.ui.element_entity_events.selected_entries);
    
    // transform
    
    Camera.ui.element_entity_pos_x.interactive=false;
    Camera.ui.element_entity_pos_y.interactive=false;
    Camera.ui.element_entity_pos_z.interactive=false;
    Camera.ui.element_entity_offset_x.interactive=false;
    Camera.ui.element_entity_offset_y.interactive=false;
    Camera.ui.element_entity_offset_z.interactive=false;
    Camera.ui.element_entity_rot_x.interactive=false;
    Camera.ui.element_entity_rot_y.interactive=false;
    Camera.ui.element_entity_rot_z.interactive=false;
    Camera.ui.element_entity_scale_x.interactive=false;
    Camera.ui.element_entity_scale_y.interactive=false;
    Camera.ui.element_entity_scale_z.interactive=false;
    
    // entity-mob
    
    Camera.ui.element_entity_mob_frame.value="0";
    Camera.ui.element_entity_mob_frame.interactive=false;
    Camera.ui.element_entity_mob_direction.value=0;
    Camera.ui.element_entity_mob_direction.interactive=false;
    Camera.ui.element_entity_mob_animating.value=false;
    Camera.ui.element_entity_mob_animating.interactive=false;
} else if (ds_list_size(list)==1) {
    safa_on_select(list[| 0]);
} else {
    // populate the UI elements with a nice ¯\_(ツ)_/¯
    Camera.ui.element_entity_name.value="";
    Camera.ui.element_entity_solid.value=2;
    Camera.ui.element_entity_static.value=2;
    
    ds_map_clear(Camera.ui.element_entity_events.selected_entries);
    
    Camera.ui.element_entity_name.interactive=true;
    Camera.ui.element_entity_solid.interactive=true;
    Camera.ui.element_entity_static.interactive=true;
    
    Camera.ui.element_entity_events.interactive=false;
    Camera.ui.element_entity_event_add.interactive=false;
    Camera.ui.element_entity_event_remove.interactive=false;
    Camera.ui.element_entity_event_edit.interactive=false;
    
    Camera.ui.element_entity_option_animate_idle.value=2;
    Camera.ui.element_entity_option_animate_movement.value=2;
    Camera.ui.element_entity_option_direction_fix.value=2;
    
    Camera.ui.element_entity_option_animate_idle.interactive=true;
    Camera.ui.element_entity_option_animate_movement.interactive=true;
    Camera.ui.element_entity_option_direction_fix.interactive=true;
    
    Camera.ui.element_entity_autonomous_movement.interactive=false;
    
    // transform - position is disabled when multiple entities are selected because
    // you do NOT want to pile everything into the same cell
    
    // not all of these things may be valid for the type of selected entities, but
    // we'll pretend that they are. the onvaluechange should check to see if you're
    // allowed to do the operation also, anyway.
    
    Camera.ui.element_entity_pos_x.interactive=false;
    Camera.ui.element_entity_pos_y.interactive=false;
    Camera.ui.element_entity_pos_z.interactive=false;
    Camera.ui.element_entity_offset_x.interactive=true;
    Camera.ui.element_entity_offset_y.interactive=true;
    Camera.ui.element_entity_offset_z.interactive=true;
    Camera.ui.element_entity_rot_x.interactive=true;
    Camera.ui.element_entity_rot_y.interactive=true;
    Camera.ui.element_entity_rot_z.interactive=true;
    Camera.ui.element_entity_scale_x.interactive=true;
    Camera.ui.element_entity_scale_y.interactive=true;
    Camera.ui.element_entity_scale_z.interactive=true;
    
    Camera.ui.element_entity_pos_x.value="";
    Camera.ui.element_entity_pos_y.value="";
    Camera.ui.element_entity_pos_z.value="";
    Camera.ui.element_entity_offset_x.value="";
    Camera.ui.element_entity_offset_y.value="";
    Camera.ui.element_entity_offset_z.value="";
    Camera.ui.element_entity_rot_x.value="";
    Camera.ui.element_entity_rot_y.value="";
    Camera.ui.element_entity_rot_z.value="";
    Camera.ui.element_entity_scale_x.value="";
    Camera.ui.element_entity_scale_y.value="";
    Camera.ui.element_entity_scale_z.value="";
    
    if (selection_all_pawn()) {
        Camera.ui.element_entity_mob_frame.value="0";
        Camera.ui.element_entity_mob_direction.value=0;
        Camera.ui.element_entity_mob_animating.value=2;
        
        Camera.ui.element_entity_mob_frame.interactive=true;
        Camera.ui.element_entity_mob_direction.interactive=true;
        Camera.ui.element_entity_mob_animating.interactive=true;
    } else {
        Camera.ui.element_entity_mob_frame.value="0";
        Camera.ui.element_entity_mob_direction.value=0;
        Camera.ui.element_entity_mob_animating.value=0;
        
        Camera.ui.element_entity_mob_frame.interactive=false;
        Camera.ui.element_entity_mob_direction.interactive=false;
        Camera.ui.element_entity_mob_animating.interactive=false;
    }
}
