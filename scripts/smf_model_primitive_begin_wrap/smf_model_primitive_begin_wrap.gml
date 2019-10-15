/// @description smf_model_primitive_begin_wrap(modelIndex, kind, maxTriangles)
/// @param modelIndex
/// @param kind
/// @param maxTriangles
var modelIndex = argument0;
var modArray = modelIndex[| SMF_model.VBuff];
var bufArray = modelIndex[| SMF_model.MBuff];
modelIndex[| SMF_model.Kind] = argument1;

if is_array(modArray){vertex_delete_buffer(modArray[0]);}
if is_array(bufArray){buffer_delete(bufArray[0]);}
bufArray[0] = buffer_create(argument2 * SMF_format_bytes*3, buffer_wrap, 1);

modelIndex[| SMF_model.MBuff] = bufArray;
modelIndex[| SMF_model.VBuff] = -1;
modelIndex[| SMF_model.MaterialIndex] = [0];
modelIndex[| SMF_model.Visible] = [true];