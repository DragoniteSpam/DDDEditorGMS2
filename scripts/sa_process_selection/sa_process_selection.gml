function sa_process_selection() {
    // could use selection_count() here but you may need to access
    // element(s) of the list so that won't work
    
    var list = selection_all();
    var map = Stuff.map.active_map;
    
    ds_list_destroy(Stuff.map.selected_entities);
    Stuff.map.selected_entities = list;
    
    if (ds_list_empty(list)) {
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
        Stuff.map.ui.element_effect_com_marker.interactive = false;
    } else {
        // being able to use the on select script for this would be nice,
        // except it depends rather heavily on whether or not each of the
        // entities share a common type
        var single = ds_list_size(list) == 1;
        var first = list[| 0];
        ui_input_set_value(Stuff.map.ui.element_entity_name, single ? first.name : "");
        Stuff.map.ui.element_entity_static.value = single ? first.is_static : 2;
        
        ui_list_deselect(Stuff.map.ui.element_entity_events);
        
        Stuff.map.ui.element_entity_name.interactive = true;
        Stuff.map.ui.element_entity_generic.interactive = single;
        Stuff.map.ui.element_entity_static.interactive = true;
        
        if (single) {
            Stuff.map.ui.element_entity_events.interactive = true;
            Stuff.map.ui.element_entity_event_add.interactive = true;
            Stuff.map.ui.element_entity_event_remove.interactive = true;
            Stuff.map.ui.element_entity_event_edit.interactive = true;
            
            if (array_empty(single)) {
                // this has to be done manually since the list doesn't have an actual
                // list assigned to it (which it may be a good idea to change in the
                // future, but for now this will do)
                Stuff.map.ui.element_entity_events.index = 0;
                ui_list_select(Stuff.map.ui.element_entity_events, 0, true);
            }
        } else {
            Stuff.map.ui.element_entity_events.interactive = false;
            Stuff.map.ui.element_entity_event_add.interactive = false;
            Stuff.map.ui.element_entity_event_remove.interactive = false;
            Stuff.map.ui.element_entity_event_edit.interactive = false;
        }
        
        Stuff.map.ui.element_entity_option_direction_fix.value = single ? first.direction_fix : 2;
        Stuff.map.ui.element_entity_option_always_update.value = single ? first.always_update : 2;
        Stuff.map.ui.element_entity_option_preserve.value = single ? first.preserve_on_save : 2;
        Stuff.map.ui.element_entity_option_reflect.value = single ? first.reflect : 2;
        
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
        Stuff.map.ui.element_entity_pos_x.interactive = single;
        Stuff.map.ui.element_entity_pos_y.interactive = single;
        Stuff.map.ui.element_entity_pos_z.interactive = single;
        Stuff.map.ui.element_entity_offset_x.interactive = true;
        Stuff.map.ui.element_entity_offset_y.interactive = true;
        Stuff.map.ui.element_entity_offset_z.interactive = true;
        Stuff.map.ui.element_entity_rot_x.interactive = true;
        Stuff.map.ui.element_entity_rot_y.interactive = true;
        Stuff.map.ui.element_entity_rot_z.interactive = true;
        Stuff.map.ui.element_entity_scale_x.interactive = true;
        Stuff.map.ui.element_entity_scale_y.interactive = true;
        Stuff.map.ui.element_entity_scale_z.interactive = true;
        
        ui_input_set_value(Stuff.map.ui.element_entity_pos_x, single ? first.xx : "");
        ui_input_set_value(Stuff.map.ui.element_entity_pos_y, single ? first.yy : "");
        ui_input_set_value(Stuff.map.ui.element_entity_pos_z, single ? first.zz : "");
        ui_input_set_value(Stuff.map.ui.element_entity_offset_x, single ? first.off_xx : "");
        ui_input_set_value(Stuff.map.ui.element_entity_offset_y, single ? first.off_yy : "");
        ui_input_set_value(Stuff.map.ui.element_entity_offset_z, single ? first.off_zz : "");
        ui_input_set_value(Stuff.map.ui.element_entity_rot_x, single ? first.rot_xx : "");
        ui_input_set_value(Stuff.map.ui.element_entity_rot_y, single ? first.rot_yy : "");
        ui_input_set_value(Stuff.map.ui.element_entity_rot_z, single ? first.rot_zz : "");
        ui_input_set_value(Stuff.map.ui.element_entity_scale_x, single ? first.scale_xx : "");
        ui_input_set_value(Stuff.map.ui.element_entity_scale_y, single ? first.scale_yy : "");
        ui_input_set_value(Stuff.map.ui.element_entity_scale_z, single ? first.scale_zz : "");
        
        var type = selection_all_type(list);
        var suffix = (ds_list_size(list) > 1) ? " (" + string(ds_list_size(list)) + ")" : "";
        
        Stuff.map.ui.element_entity_type.text = "Type: " + type.name + suffix;
        
        switch (type.id) {
            case ETypes.ENTITY_TILE:
                break;
            case ETypes.ENTITY_MESH_AUTO:
                // only allow this for individual entities
                Stuff.map.ui.element_entity_mesh_autotile_data.interactive = true;
                // fallthrough
            case ETypes.ENTITY_MESH:
                Stuff.map.ui.element_entity_mesh_animated.value = single ? first.animated : 2;
                Stuff.map.ui.element_entity_mesh_animated.interactive = true;
                
                ui_input_set_value(Stuff.map.ui.element_entity_mesh_animation_speed, single ? first.animation_speed : "");
                Stuff.map.ui.element_entity_mesh_animation_speed.interactive = true;
                Stuff.map.ui.element_entity_mesh_animation_end_action.value = single ? first.animation_end_action : -1;
                Stuff.map.ui.element_entity_mesh_animation_end_action.interactive = true;
                
                Stuff.map.ui.element_entity_mesh_list.interactive = true;
                Stuff.map.ui.element_entity_mesh_submesh.interactive = true;
                ui_list_deselect(Stuff.map.ui.element_entity_mesh_list);
                ui_list_deselect(Stuff.map.ui.element_entity_mesh_submesh);
                
                if (single) {
                    var mesh_data = guid_get(first.mesh);
                     ui_list_select(Stuff.map.ui.element_entity_mesh_list, array_search(Game.meshes, mesh_data), true);
                    Stuff.map.ui.element_entity_mesh_submesh.entries = mesh_data.submeshes;
                    ui_list_select(Stuff.map.ui.element_entity_mesh_submesh, proto_guid_get(mesh_data, first.mesh_submesh), true);
                } else {
                    // if all selected meshes use the same submesh, you may select it in the
                    // list and show the available submeshes; otherwise the list should be
                    // deselected and the submesh list should be empty
                    var mesh = undefined;
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
                            mesh = undefined;
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
                }
                break;
            case ETypes.ENTITY_PAWN:
                Stuff.map.ui.element_entity_pawn_frame.value = single ? string(first.frame) : "0";
                Stuff.map.ui.element_entity_pawn_direction.value = single ? first.map_direction : -1;
                Stuff.map.ui.element_entity_pawn_animating.value = single ? first.is_animating : 2;
                
                ui_list_deselect(Stuff.map.ui.element_entity_pawn_sprite);
                
                if (single) {
                    for (var i = 0; i < array_length(Game.graphics.overworlds); i++) {
                        if (Game.graphics.overworlds[i].GUID == first.overworld_sprite) {
                            ui_list_select(Stuff.map.ui.element_entity_pawn_sprite, i, true);
                            break;
                        }
                    }
                }
                
                Stuff.map.ui.element_entity_pawn_frame.interactive = true;
                Stuff.map.ui.element_entity_pawn_direction.interactive = true;
                Stuff.map.ui.element_entity_pawn_animating.interactive = true;
                Stuff.map.ui.element_entity_pawn_sprite.interactive = true;
                break;
            case ETypes.ENTITY_EFFECT:
                // this could be a bit dangerous if you have more than one effect
                // selected, i'm not going to stop you
                Stuff.map.ui.element_effect_com_light.interactive = true;
                Stuff.map.ui.element_effect_com_particle.interactive = true;
                Stuff.map.ui.element_effect_com_audio.interactive = true;
                Stuff.map.ui.element_effect_com_marker.interactive = true;
                break;
        }
    }
}