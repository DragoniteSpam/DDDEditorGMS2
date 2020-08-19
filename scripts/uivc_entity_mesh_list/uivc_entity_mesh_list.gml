/// @param UIList
function uivc_entity_mesh_list(argument0) {

    var list = argument0;
    var mesh = Stuff.all_meshes[| ui_list_selection(list)];

    // this assumes that every selected entity is already an instance of Mesh
    var entities = Stuff.map.selected_entities;

    for (var i = 0; i < ds_list_size(entities); i++) {
        // if the mesh changes, you should probably also reset the proto guid
        if (guid_get(entities[| i].mesh) != mesh) {
            entities[| i].mesh_submesh = mesh.first_proto_guid;
        }
        entities[| i].mesh = mesh.GUID;
    }

    batch_again();

    Stuff.map.ui.element_entity_mesh_submesh.entries = mesh.submeshes;
    ui_list_deselect(Stuff.map.ui.element_entity_mesh_submesh);
    ui_list_select(Stuff.map.ui.element_entity_mesh_submesh, proto_guid_get(mesh, mesh.first_proto_guid), true);


}
