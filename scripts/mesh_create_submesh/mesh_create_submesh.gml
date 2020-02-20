/// @param DataMesh
/// @param buffer
/// @param vbuffer
/// @param wbuffer
/// @param [proto-guid]

var mesh = argument[0];
var buffer = argument[1];
var vbuffer = argument[2];
var wbuffer = argument[3];
var proto_guid = (argument_count > 4) ? argument[4] : -1;

proto_guid_set(mesh, ds_list_size(mesh.submeshes), proto_guid);

var submesh = instance_create_depth(0, 0, 0, MeshSubmesh);
instance_deactivate_object(submesh);
submesh.name = "Submesh" + string(ds_list_size(mesh.submeshes));
submesh.buffer = buffer;
submesh.vbuffer = vbuffer;
submesh.wbuffer = wbuffer;

submesh.owner = mesh;

ds_list_add(mesh.submeshes, submesh);