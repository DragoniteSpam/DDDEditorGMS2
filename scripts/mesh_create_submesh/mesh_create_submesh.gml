/// @param DataMesh
/// @param buffer
/// @param vbuffer
/// @param wbuffer
/// @param [proto-guid]
/// @param [name]
/// @param replace-index

var mesh = argument[0];
var buffer = argument[1];
var vbuffer = argument[2];
var wbuffer = argument[3];
var proto_guid = (argument_count > 4 && argument[4] != undefined) ? argument[4] : -1;
var name = (argument_count > 5 && argument[5] != undefined) ? argument[5] : "Submesh" + string(ds_list_size(mesh.submeshes));
var replace_index = (argument_count > 6 && argument[6] != undefined) ? argument[6] : -1;

var submesh = mesh.submeshes[| replace_index];

if (submesh) {
    buffer_delete(submesh.buffer);
    vertex_delete_buffer(submesh.vbuffer);
    vertex_delete_buffer(submesh.wbuffer);
} else {
    proto_guid_set(mesh, ds_list_size(mesh.submeshes), proto_guid);
    var submesh = instance_create_depth(0, 0, 0, MeshSubmesh);
    instance_deactivate_object(submesh);
    submesh.name = name;
    submesh.owner = mesh;
    ds_list_add(mesh.submeshes, submesh);
}

submesh.buffer = buffer;
submesh.vbuffer = vbuffer;
submesh.wbuffer = wbuffer;