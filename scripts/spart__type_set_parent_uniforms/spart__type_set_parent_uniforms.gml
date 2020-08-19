/// @description spart__type_set_parent_uniforms(uniformIndex, partType, step);
/// @param uniformIndex
/// @param partType
/// @param step
function spart__type_set_parent_uniforms(argument0, argument1, argument2) {
    /*
        Sets the uniforms of the parent particle type. Used when drawing secondary particles.
    
        Script created by TheSnidr
        www.TheSnidr.com
    */
    var i = argument0;
    var partType = argument1;
    var step = argument2;
    var g = sPartUniformGrid;
    shader_set_uniform_i(g[# sPartUni.step, i], step);
    shader_set_uniform_f(g[# sPartUni.parentPartLife, i], partType[| sPartTyp.LifeMin], partType[| sPartTyp.LifeMax]);
    shader_set_uniform_f_array(g[# sPartUni.parentPartSpd, i], partType[| sPartTyp.Speed]);
    shader_set_uniform_f_array(g[# sPartUni.parentPartDir, i], partType[| sPartTyp.Dir]);
    shader_set_uniform_f_array(g[# sPartUni.parentPartGrav, i], partType[| sPartTyp.GravDir]);
    shader_set_uniform_i(g[# sPartUni.parentPartDirRad, i], partType[| sPartTyp.DirRadial]);
    shader_set_uniform_f(g[# sPartUni.parentPartSpawnNum, i], step ? partType[| sPartTyp.StepNumber] : partType[| sPartTyp.DeathNumber]);


}
