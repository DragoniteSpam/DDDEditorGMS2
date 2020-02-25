/// @description stdf_load_obj(fname)
/// @param fname
/*
Loads an .obj model into a buffer
*/
var filename = argument0;
var mbuff = stdf_load_obj_to_buffer(filename);
if (mbuff < 0){return -1;}
var vbuff = vertex_create_buffer_from_buffer(mbuff, global.stdFormat);
buffer_delete(mbuff);
return vbuff;