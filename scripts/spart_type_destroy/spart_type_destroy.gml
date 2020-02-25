/// @description spart_type_destroy(partTypeInd)
/// @param partTypeInd
/*
	Destroys the given particle type

	Script created by TheSnidr
	www.thesnidr.com
*/
var partType = argument0;
if partType[| sPartTyp.Spr] != -1
{	//If a new sprite has been generated for this particle type before, delete it
	sprite_delete(partType[| sPartTyp.Spr]);
}
if partType[| sPartTyp.MeshEnabled]
{	//If a mesh vbuff exists, delete it
	vertex_delete_buffer(partType[| sPartTyp.MeshVbuff]);
}
ds_list_destroy(partType);