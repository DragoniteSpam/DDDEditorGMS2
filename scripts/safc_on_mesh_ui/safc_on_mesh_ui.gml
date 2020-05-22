/// @param EntityMesh

var mesh = argument0;

safc_on_entity_ui(mesh);

if (instanceof(mesh, EntityMeshAutotile)) {
    // turn these on
    Stuff.map.ui.element_entity_mesh_autotile_data.interactive = true;
    
    // turn these off
    Stuff.map.ui.element_entity_mesh_animated.interactive = false;
    Stuff.map.ui.element_entity_mesh_animation_speed.interactive = false;
    Stuff.map.ui.element_entity_mesh_animation_end_action.interactive = false;
    Stuff.map.ui.element_entity_mesh_list.interactive = false;
    Stuff.map.ui.element_entity_mesh_submesh.interactive = false;
} else {
    // turn these on
    Stuff.map.ui.element_entity_mesh_animated.value = mesh.animated;
    Stuff.map.ui.element_entity_mesh_animated.interactive = true;
    ui_input_set_value(Stuff.map.ui.element_entity_mesh_animation_speed, string(mesh.animation_speed));
    Stuff.map.ui.element_entity_mesh_animation_speed.interactive = true;
    Stuff.map.ui.element_entity_mesh_animation_end_action.value = mesh.animation_end_action;
    Stuff.map.ui.element_entity_mesh_animation_end_action.interactive = true;
    
    var mesh_data = guid_get(mesh.mesh);
    ui_list_deselect(Stuff.map.ui.element_entity_mesh_list);
    ui_list_select(Stuff.map.ui.element_entity_mesh_list, ds_list_find_index(Stuff.all_meshes, mesh_data), true);
    Stuff.map.ui.element_entity_mesh_list.interactive = true;
    Stuff.map.ui.element_entity_mesh_submesh.entries = mesh_data.submeshes;
    ui_list_deselect(Stuff.map.ui.element_entity_mesh_submesh);
    ui_list_select(Stuff.map.ui.element_entity_mesh_submesh, proto_guid_get(mesh_data, mesh.mesh_submesh), true);
    Stuff.map.ui.element_entity_mesh_submesh.interactive = true;
    
    // turn these off
    Stuff.map.ui.element_entity_mesh_autotile_data.interactive = false;
}