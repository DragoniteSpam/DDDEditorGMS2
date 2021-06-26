function sa_process_selection() {
    // could use selection_count() here but you may need to access
    // element(s) of the list so that won't work
    
    var list = selection_all();
    var map = Stuff.map.active_map;
    
    for (var i = 0; i < ds_list_size(Stuff.map.selected_entities); i++) {
        Stuff.map.selected_entities[| i].on_deselect(Stuff.map.selected_entities[| i]);
    }
    
    ds_list_destroy(Stuff.map.selected_entities);
    Stuff.map.selected_entities = list;
    
    for (var i = 0; i < ds_list_size(Stuff.map.selected_entities); i++) {
        Stuff.map.selected_entities[| i].on_select(Stuff.map.selected_entities[| i]);
    }
    
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
        
        Stuff.map.ui.element_entity_option_direction_fix.interactive = false;
        Stuff.map.ui.element_entity_option_always_update.interactive = false;
        Stuff.map.ui.element_entity_option_autonomous_movement.interactive = false;
        Stuff.map.ui.element_entity_option_preserve.interactive = false;
        Stuff.map.ui.element_entity_option_reflect.interactive = false;
        
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
        Stuff.map.ui.element_entity_mesh_animation_speed.interactive = false;
        Stuff.map.ui.element_entity_mesh_autotile_data.interactive = false;
        Stuff.map.ui.element_entity_mesh_animation_end_action.interactive = false;
        Stuff.map.ui.element_entity_mesh_submesh.interactive = false;
        Stuff.map.ui.element_entity_mesh_list.interactive = false;
        
        // entity-pawn
        ui_input_set_value(Stuff.map.ui.element_entity_pawn_frame, "0");
        Stuff.map.ui.element_entity_pawn_frame.interactive = false;
        Stuff.map.ui.element_entity_pawn_direction.value = 0;
        Stuff.map.ui.element_entity_pawn_direction.interactive = false;
        Stuff.map.ui.element_entity_pawn_animating.value = false;
        Stuff.map.ui.element_entity_pawn_animating.interactive = false;
        Stuff.map.ui.element_entity_pawn_sprite.interactive = false;
        ui_list_deselect(Stuff.map.ui.element_entity_pawn_sprite);
        
        // entity-effect
        Stuff.map.ui.element_effect_com_light.interactive = false;
        Stuff.map.ui.element_effect_com_particle.interactive = false;
        Stuff.map.ui.element_effect_com_audio.interactive = false;
    } else if (ds_list_size(list) == 1) {
        safa_on_select_ui(list[| 0]);
    } else {
        // being able to use the on select script for this would be nice,
        // except it depends rather heavily on whether or not each of the
        // entities share a common type
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
        
        Stuff.map.ui.element_entity_option_direction_fix.value = 2;
        Stuff.map.ui.element_entity_option_always_update.value = 2;
        Stuff.map.ui.element_entity_option_preserve.value = 2;
        Stuff.map.ui.element_entity_option_reflect.value = 2;
        
        Stuff.map.ui.element_entity_option_direction_fix.interactive = true;
        Stuff.map.ui.element_entity_option_always_update.interactive = true;
        Stuff.map.ui.element_entity_option_autonomous_movement.interactive = false;
        Stuff.map.ui.element_entity_option_preserve.interactive = true;
        Stuff.map.ui.element_entity_option_reflect.interactive = true;
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
        
        var type = selection_all_type(list);
        var suffix = (ds_list_size(list) > 0) ? " (" + string(ds_list_size(list)) + ")" : "";
        
        Stuff.map.ui.element_entity_type.text = "Type: " + object_get_name(type) + suffix;
        
        switch (type) {
            case ETypeFlags.ENTITY_TILE:
                break;
            case ETypeFlags.ENTITY_MESH_AUTO:
                // only allow this for individual entities
                Stuff.map.ui.element_entity_mesh_autotile_data.interactive = true;
                // fallthrough
            case ETypeFlags.ENTITY_MESH:
                Stuff.map.ui.element_entity_mesh_animated.value = 2;
                Stuff.map.ui.element_entity_mesh_animated.interactive = true;
                ui_list_deselect(Stuff.map.ui.element_entity_mesh_list);
                ui_list_deselect(Stuff.map.ui.element_entity_mesh_submesh);
                
                // if all selected meshes use the same submesh, you may select it in the
                // list and show the available submeshes; otherwise the list should be
                // deselected and the submesh list should be empty
                var mesh = noone;
                for (var i = 0; i < ds_list_size(list); i++) {
                    var mesh_data = guid_get(list[| i].mesh);
                    if (!mesh) {
                        if (mesh_data) {
                            mesh = mesh_data;
                            ui_list_select(Stuff.map.ui.element_entity_mesh_list, array_search(Game.meshes, mesh), true);
                            Stuff.map.ui.element_entity_mesh_submesh.entries = mesh.submeshes;
                            continue;
                        }
                    }
                    if (mesh != mesh_data) {
                        ui_list_deselect(Stuff.map.ui.element_entity_mesh_list);
                        Stuff.map.ui.element_entity_mesh_submesh.entries = noone;
                        mesh = noone;
                        break;
                    }
                }
                // if all meshes use the same mesh, you may check to see if they all
                // share the same submesh, as well
                if (mesh) {
                    var submesh = NULL;
                    for (var i = 0; i < ds_list_size(list); i++) {
                        var submesh_data = list[| i].mesh_submesh;
                        if (submesh == NULL) {
                            submesh = submesh_data;
                            ui_list_select(Stuff.map.ui.element_entity_mesh_submesh, proto_guid_get(mesh, submesh), true);
                            continue;
                        }
                        if (submesh != submesh_data) {
                            ui_list_deselect(Stuff.map.ui.element_entity_mesh_submesh);
                            break;
                        }
                    }
                }
                break;
            case ETypeFlags.ENTITY_PAWN:
                Stuff.map.ui.element_entity_pawn_frame.value = "0";
                Stuff.map.ui.element_entity_pawn_direction.value = 0;
                Stuff.map.ui.element_entity_pawn_animating.value = 2;
                ui_list_deselect(Stuff.map.ui.element_entity_pawn_sprite);
                
                Stuff.map.ui.element_entity_pawn_frame.interactive = true;
                Stuff.map.ui.element_entity_pawn_direction.interactive = true;
                Stuff.map.ui.element_entity_pawn_animating.interactive = true;
                Stuff.map.ui.element_entity_pawn_sprite.interactive = true;
                break;
            case ETypeFlags.ENTITY_EFFECT:
                // this could be a bit dangerous if you have more than one effect
                // selected, i'm not going to stop you
                Stuff.map.ui.element_effect_com_light.interactive = true;
                Stuff.map.ui.element_effect_com_particle.interactive = true;
                Stuff.map.ui.element_effect_com_audio.interactive = true;
                break;
        }
    }
}