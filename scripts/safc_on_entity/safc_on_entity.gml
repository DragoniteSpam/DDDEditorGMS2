/// @param Entity

var entity  =  argument0;

// basic stuff

Camera.ui.element_entity_name.value = entity.name;
Camera.ui.element_entity_solid.value = entity.am_solid;
Camera.ui.element_entity_static.value = entity.static;

Camera.ui.element_entity_name.interactive = true;
Camera.ui.element_entity_solid.interactive = true;
Camera.ui.element_entity_static.interactive = true;

Camera.ui.element_entity_events.interactive = true;
Camera.ui.element_entity_event_add.interactive = true;
Camera.ui.element_entity_event_remove.interactive = true;
Camera.ui.element_entity_event_edit.interactive = true;
    
Camera.ui.element_entity_option_animate_idle.value = entity.animate_idle;
Camera.ui.element_entity_option_animate_movement.value = entity.animate_movement;
Camera.ui.element_entity_option_direction_fix.value = entity.direction_fix;
Camera.ui.element_entity_option_reset_position.value = entity.reset_position;
    
Camera.ui.element_entity_option_animate_idle.interactive = true;
Camera.ui.element_entity_option_animate_movement.interactive = true;
Camera.ui.element_entity_option_direction_fix.interactive = true;
Camera.ui.element_entity_option_reset_position.interactive = true;
Camera.ui.element_entity_option_autonomous_movement.interactive = true;

// transform

Camera.ui.element_entity_pos_x.interactive = entity.translateable;
Camera.ui.element_entity_pos_y.interactive = entity.translateable;
Camera.ui.element_entity_pos_z.interactive = entity.translateable;
Camera.ui.element_entity_offset_x.interactive = entity.offsettable;
Camera.ui.element_entity_offset_y.interactive = entity.offsettable;
Camera.ui.element_entity_offset_z.interactive = entity.offsettable;
Camera.ui.element_entity_rot_x.interactive = entity.rotateable;
Camera.ui.element_entity_rot_y.interactive = entity.rotateable;
Camera.ui.element_entity_rot_z.interactive = entity.rotateable;
Camera.ui.element_entity_scale_x.interactive = entity.scalable;
Camera.ui.element_entity_scale_y.interactive = entity.scalable;
Camera.ui.element_entity_scale_z.interactive = entity.scalable;

Camera.ui.element_entity_pos_x.value = string(entity.xx);
Camera.ui.element_entity_pos_y.value = string(entity.yy);
Camera.ui.element_entity_pos_z.value = string(entity.zz);
Camera.ui.element_entity_offset_x.value = string(entity.off_xx);
Camera.ui.element_entity_offset_y.value = string(entity.off_yy);
Camera.ui.element_entity_offset_z.value = string(entity.off_zz);
Camera.ui.element_entity_rot_x.value = string(entity.rot_xx);
Camera.ui.element_entity_rot_y.value = string(entity.rot_yy);
Camera.ui.element_entity_rot_z.value = string(entity.rot_zz);
Camera.ui.element_entity_scale_x.value = string(entity.scale_xx);
Camera.ui.element_entity_scale_y.value = string(entity.scale_yy);
Camera.ui.element_entity_scale_z.value = string(entity.scale_zz);