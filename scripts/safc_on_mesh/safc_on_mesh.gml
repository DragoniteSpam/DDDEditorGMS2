/// @param EntityMesh

var mesh = argument0;

safc_on_entity(mesh);

Camera.ui.element_entity_mesh_animated.value = mesh.animated;

Camera.ui.element_entity_mesh_animated.interactive = true;