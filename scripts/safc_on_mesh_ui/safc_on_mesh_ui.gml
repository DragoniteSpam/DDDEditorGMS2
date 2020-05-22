/// @param EntityMesh

var mesh = argument0;

safc_on_entity_ui(mesh);

Stuff.map.ui.element_entity_mesh_animated.value = mesh.animated;
Stuff.map.ui.element_entity_mesh_animated.interactive = true;
ui_input_set_value(Stuff.map.ui.element_entity_mesh_animation_speed, mesh.animation_speed);
Stuff.map.ui.element_entity_mesh_animation_speed.interactive = true;
Stuff.map.ui.element_entity_mesh_animation_end_action.value = mesh.animation_end_action;
Stuff.map.ui.element_entity_mesh_animation_end_action.interactive = true;

Stuff.map.ui.element_entity_mesh_autotile_data.interactive = instanceof(mesh, EntityMeshAutotile);