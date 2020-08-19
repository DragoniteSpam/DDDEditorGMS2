/// @description spart__get_uniform_index(shader)
/// @param shader
function spart__get_uniform_index(argument0) {
    /*
        Returns the uniform index of the given shader.
        If the shader has not been indexed previously, get the relevant shader uniforms.
    
        Script created by TheSnidr
        www.TheSnidr.com
    */
    var shader = argument0;
    var i = sPartUniformMap[? shader];

    if is_undefined(i)
    {
        var g = sPartUniformGrid;
        i = ds_map_size(sPartUniformMap);
        sPartUniformMap[? shader] = i;
    
        if ds_grid_height(g) <= i
        {
            ds_grid_resize(g, sPartUni.Num, i+1);
        }
    
        //Batch info
        g[# sPartUni.batchInd, i] = shader_get_uniform(shader, "u_batchInd")
        g[# sPartUni.partNum, i] = shader_get_uniform(shader, "u_partNum")
    
        //Emitter uniforms
        g[# sPartUni.emStartMat, i] = shader_get_uniform(shader, "u_EmStartMat");
        g[# sPartUni.emEndMat, i] = shader_get_uniform(shader, "u_EmEndMat");
        g[# sPartUni.emLifeSpan, i] = shader_get_uniform(shader, "u_EmLifeSpan");
        g[# sPartUni.emTimeAlive, i] = shader_get_uniform(shader, "u_EmTimeAlive");
        g[# sPartUni.emShapeDistrBurstID, i] = shader_get_uniform(shader, "u_EmShapeDistrBurstID");
        g[# sPartUni.emPartsPerStep, i] = shader_get_uniform(shader, "u_EmPtsPerStep");
        g[# sPartUni.emSector, i] = shader_get_uniform(shader, "u_EmSector");
        g[# sPartUni.emMeshOffset, i] = shader_get_uniform(shader, "u_EmMeshOffset");
    
        //Particle type uniforms
        g[# sPartUni.partSprOrig, i] = shader_get_uniform(shader, "u_PtSprOrig");
        g[# sPartUni.partSprAnimImgNum, i] = shader_get_uniform(shader, "u_PtSprImgNum");
        g[# sPartUni.partSprAnimSpd, i] = shader_get_uniform(shader, "u_PtSprSpd");
        g[# sPartUni.partLife, i] = shader_get_uniform(shader, "u_PtLife");
        g[# sPartUni.partSize, i] = shader_get_uniform(shader, "u_PtSize");
        g[# sPartUni.partAngle, i] = shader_get_uniform(shader, "u_PtAngle");
        g[# sPartUni.partAngleRel, i] = shader_get_uniform(shader, "u_PtAngleRel");
        g[# sPartUni.partSpd, i] = shader_get_uniform(shader, "u_PtSpd");
        g[# sPartUni.partDir, i] = shader_get_uniform(shader, "u_PtDir");
        g[# sPartUni.partDirRad, i] = shader_get_uniform(shader, "u_PtDirRadial");
        g[# sPartUni.partGrav, i] = shader_get_uniform(shader, "u_PtGravVec");
        g[# sPartUni.partCol, i] = shader_get_uniform(shader, "u_PtCol");
        g[# sPartUni.partColType, i] = shader_get_uniform(shader, "u_PtColType");
        g[# sPartUni.partAlphaTestRef, i] = shader_get_uniform(shader, "u_PtAlphaTestRef");

        //Secondary particle uniforms
        g[# sPartUni.step, i] = shader_get_uniform(shader, "u_step");
        g[# sPartUni.parentPartLife, i] = shader_get_uniform(shader, "u_parPtLife");
        g[# sPartUni.parentPartSpd, i] = shader_get_uniform(shader, "u_parPtSpd");
        g[# sPartUni.parentPartDir, i] = shader_get_uniform(shader, "u_parPtDir");
        g[# sPartUni.parentPartGrav, i] = shader_get_uniform(shader, "u_parPtGravVec");
        g[# sPartUni.parentPartDirRad, i] = shader_get_uniform(shader, "u_parPtDirRadial");
        g[# sPartUni.parentPartSpawnNum, i] = shader_get_uniform(shader, "u_parPtSpawnNum");

        //Mesh particle uniforms
        g[# sPartUni.partMeshRotAxis, i] = shader_get_uniform(shader, "u_PtMeshRotAxis");
        g[# sPartUni.partMeshAmbCol, i] = shader_get_uniform(shader, "u_PtMeshAmbientCol");
        g[# sPartUni.partMeshLightCol, i] = shader_get_uniform(shader, "u_PtMeshLightCol");
        g[# sPartUni.partMeshLightDir, i] = shader_get_uniform(shader, "u_PtMeshLightDir");
    }

    return i;


}
