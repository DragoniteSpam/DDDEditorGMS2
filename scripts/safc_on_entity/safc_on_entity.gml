/// @description  void safc_on_entity(Entity);
/// @param Entity

// basic stuff

Camera.ui.element_entity_name.value=argument0.name;
Camera.ui.element_entity_solid.value=argument0.am_solid;
Camera.ui.element_entity_static.value=argument0.static;

Camera.ui.element_entity_name.interactive=true;
Camera.ui.element_entity_solid.interactive=true;
Camera.ui.element_entity_static.interactive=true;

Camera.ui.element_entity_events.interactive=true;
Camera.ui.element_entity_event_add.interactive=true;
Camera.ui.element_entity_event_remove.interactive=true;
Camera.ui.element_entity_event_edit.interactive=true;
    
Camera.ui.element_entity_option_animate_idle.value=argument0.animate_idle;
Camera.ui.element_entity_option_animate_movement.value=argument0.animate_movement;
Camera.ui.element_entity_option_direction_fix.value=argument0.direction_fix;
    
Camera.ui.element_entity_option_animate_idle.interactive=true;
Camera.ui.element_entity_option_animate_movement.interactive=true;
Camera.ui.element_entity_option_direction_fix.interactive=true;
Camera.ui.element_entity_autonomous_movement.interactive=true;

// transform

Camera.ui.element_entity_pos_x.interactive=argument0.translateable;
Camera.ui.element_entity_pos_y.interactive=argument0.translateable;
Camera.ui.element_entity_pos_z.interactive=argument0.translateable;
Camera.ui.element_entity_offset_x.interactive=argument0.offsettable;
Camera.ui.element_entity_offset_y.interactive=argument0.offsettable;
Camera.ui.element_entity_offset_z.interactive=argument0.offsettable;
Camera.ui.element_entity_rot_x.interactive=argument0.rotateable;
Camera.ui.element_entity_rot_y.interactive=argument0.rotateable;
Camera.ui.element_entity_rot_z.interactive=argument0.rotateable;
Camera.ui.element_entity_scale_x.interactive=argument0.scalable;
Camera.ui.element_entity_scale_y.interactive=argument0.scalable;
Camera.ui.element_entity_scale_z.interactive=argument0.scalable;

Camera.ui.element_entity_pos_x.value=string(argument0.xx);
Camera.ui.element_entity_pos_y.value=string(argument0.yy);
Camera.ui.element_entity_pos_z.value=string(argument0.zz);
Camera.ui.element_entity_offset_x.value=string(argument0.off_xx);
Camera.ui.element_entity_offset_y.value=string(argument0.off_yy);
Camera.ui.element_entity_offset_z.value=string(argument0.off_zz);
Camera.ui.element_entity_rot_x.value=string(argument0.rot_xx);
Camera.ui.element_entity_rot_y.value=string(argument0.rot_yy);
Camera.ui.element_entity_rot_z.value=string(argument0.rot_zz);
Camera.ui.element_entity_scale_x.value=string(argument0.scale_xx);
Camera.ui.element_entity_scale_y.value=string(argument0.scale_yy);
Camera.ui.element_entity_scale_z.value=string(argument0.scale_zz);
