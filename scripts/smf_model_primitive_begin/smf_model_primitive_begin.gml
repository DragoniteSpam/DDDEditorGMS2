/// @description smf_model_vertex_begin(modelIndex, kind)
/// @param modelIndex
/// @param kind
function smf_model_primitive_begin(argument0, argument1) {
    var modelIndex = argument0;
    var modArray = modelIndex[| SMF_model.VBuff];
    var bufArray = modelIndex[| SMF_model.MBuff];
    modelIndex[| SMF_model.Kind] = argument1;

    if is_array(modArray){vertex_delete_buffer(modArray[0]);}
    if is_array(bufArray){buffer_delete(bufArray[0]);}
    bufArray[0] = buffer_create(1, buffer_grow, 1);

    modelIndex[| SMF_model.MBuff] = bufArray;
    modelIndex[| SMF_model.VBuff] = -1;
    modelIndex[| SMF_model.MaterialIndex] = [0];
    modelIndex[| SMF_model.Visible] = [true];


}
