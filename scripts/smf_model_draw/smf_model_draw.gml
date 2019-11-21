/// @description smf_model_draw(modelIndex, [sample])
/// @param modelIndex
/// @param [sample]
var tex, nom, type, mat, modelIndex, Visible, materials, modArray, matInd, texInd, nomInd, animate, sample, m, shader, cullmode, uni, ref, clampTexCoords, shadowmap, shadowCascade, shadowEnable, texSizeArray, texSize, nomSizeArray, nomSize, refSizeArray, refSize, texUVs, refUVs, nomUVs, hmUVs, viewMat, camPos, prevMat, models;
modelIndex = argument[0];
if modelIndex < 0 or is_undefined(modelIndex){exit;}
cullmode = gpu_get_cullmode();

//Load necessary data from the model container
materials = modelIndex[| SMF_model.Material];
modArray = modelIndex[| SMF_model.VBuff];
matInd = modelIndex[| SMF_model.MaterialIndex];
texInd = modelIndex[| SMF_model.TextureIndex];
Visible = modelIndex[| SMF_model.Visible];

//Check whether or not to use shadows. If shadows are enabled, the shader selection is limited to a basic vertex shader or a basic fragment shader.
//Normal maps, reflections and outlines will be removed. However, if you'd like shadows along with special effects, you're free to create your own shaders ;)
shadowEnable = (array_length_1d(SMF_shadowmapEnabled) > 0);

//If a sample has been provided, the model will be animated
animate = false;
if argument_count > 1
{
    sample = argument[1];
    animate = true;
}

//Extract camera position from view matrix
viewMat = matrix_get(matrix_view);
camPos = [    - dot_product_3d(viewMat[SMF_X], viewMat[SMF_Y], viewMat[SMF_Z], viewMat[SMF_XTO], viewMat[SMF_YTO], viewMat[SMF_ZTO]),
            - dot_product_3d(viewMat[SMF_X], viewMat[SMF_Y], viewMat[SMF_Z], viewMat[SMF_XSI], viewMat[SMF_YSI], viewMat[SMF_ZSI]),
            - dot_product_3d(viewMat[SMF_X], viewMat[SMF_Y], viewMat[SMF_Z], viewMat[SMF_XUP], viewMat[SMF_YUP], viewMat[SMF_ZUP])];
            
//Loop through the models
prevMat = -1;
models = array_length_1d(modArray);
for (m = 0; m < models; m ++)
{
    //If this model is not visible, don't draw it
    if !Visible[m]{continue;}
    
    //Select material. If this material hasn't been used before, set its uniforms
    mat = matInd[m];
    if mat != prevMat{
        shader = materials[# mat, SMF_mat.Shader];
        if shadowEnable{
            if materials[# mat, SMF_mat.Type] == 1{
                shader = sh_smf_v_shadow;}
            if materials[# mat, SMF_mat.Type] == 2{
                shader = sh_smf_f_shadow;}}
        
        //A failsafe in case the given shader hasn't been properly compiled. It then defaults to a basic animated shader without lighting
        if !shader_is_compiled(shader){shader = sh_smf_basic;}
        if shader_is_compiled(shader){if !SMF_shader_compiled[? shader]{SMF_shader_compiled[? shader] = smf_shader_update_uniforms(shader);}}
        else{continue;}
        
        //Set the shader and the relevant uniforms
        shader_set(shader);
        uni = SMF_uniforms[? shader];
        shader_set_uniform_i(uni[SMF_uni.Animate], animate);
        if animate{shader_set_uniform_f_array(uni[SMF_uni.Sample], sample);}
        if shader != sh_smf_basic{
            //These uniforms are shared among all the shaders except for the basic one
            shader_set_uniform_f(uni[SMF_uni.CamPos], camPos[0], camPos[1], camPos[2]);
            shader_set_uniform_f_array(uni[SMF_uni.Lights], SMF_lights);
            shader_set_uniform_i(uni[SMF_uni.LightNum], array_length_1d(SMF_lights) div 8);
            shader_set_uniform_f(uni[SMF_uni.AmbientColor], SMF_ambientColor[0], SMF_ambientColor[1], SMF_ambientColor[2]);
            shader_set_uniform_f(uni[SMF_uni.SpecReflectance], materials[# mat, SMF_mat.SpecReflectance]);
            shader_set_uniform_f(uni[SMF_uni.SpecDamping], materials[# mat, SMF_mat.SpecDamping]);
            shader_set_uniform_f(uni[SMF_uni.CelSteps], materials[# mat, SMF_mat.CelSteps]);
            shader_set_uniform_f(uni[SMF_uni.RimPower], materials[# mat, SMF_mat.RimPower]);
            shader_set_uniform_f(uni[SMF_uni.RimFactor], materials[# mat, SMF_mat.RimFactor]);
            if shadowEnable{
                smf__shadowmap_update_uniforms(shader);}
            else{
                if materials[# mat, SMF_mat.NormalMapEnabled]{
                    //These uniforms only apply when there's a normal map loaded
                    tex = sprite_get_texture(SMF_textureList[| materials[# mat, SMF_mat.NormalMap]], 0);
                    texUVs = texture_get_uvs(tex);
                    shader_set_uniform_f(uni[SMF_uni.NomUVs], texUVs[0], texUVs[1], texture_get_width(tex), texture_get_height(tex));
                    texture_set_stage(uni[SMF_uni.NormalMap], tex);
                    shader_set_uniform_f(uni[SMF_uni.NormalMapFactor], materials[# mat, SMF_mat.NormalMapFactor]);
                    if materials[# mat, SMF_mat.HeightMapEnabled]{
                        //These uniforms only apply when there's a heightmap loaded
                        shader_set_uniform_f(uni[SMF_uni.HeightMapScale], materials[# mat, SMF_mat.HeightMapScale]);
                        shader_set_uniform_f(uni[SMF_uni.HeightMapMinSamples], materials[# mat, SMF_mat.HeightMapMinSamples]);
                        shader_set_uniform_f(uni[SMF_uni.HeightMapMaxSamples], materials[# mat, SMF_mat.HeightMapMaxSamples]);}}
                else if materials[# mat, SMF_mat.OutlinesEnabled]{
                    //These uniforms only apply when outlines are enabled
                    gpu_set_cullmode(cull_noculling);
                    shader_set_uniform_f(uni[SMF_uni.OutlineThickness], materials[# mat, SMF_mat.OutlineThickness] / window_get_width());
                    shader_set_uniform_f(uni[SMF_uni.OutlineColour], materials[# mat, SMF_mat.OutlineRed], materials[# mat, SMF_mat.OutlineGreen], materials[# mat, SMF_mat.OutlineBlue]);}
                if materials[# mat, SMF_mat.ReflectionsEnabled]{
                    //These uniforms only apply when there's a reflection map enabled
                    tex = sprite_get_texture(SMF_textureList[| materials[# mat, SMF_mat.ReflectionMap]], 0);
                    texUVs = texture_get_uvs(tex);
                    shader_set_uniform_f(uni[SMF_uni.RefUVs], texUVs[0], texUVs[1], texture_get_width(tex), texture_get_height(tex));
                    shader_set_uniform_f(uni[SMF_uni.ReflectionFactor], materials[# mat, SMF_mat.ReflectionFactor]);
                    texture_set_stage(uni[SMF_uni.ReflectionMap], tex);}}}
        //Save this material to the prevMat variable, so that multiple sub-models using the same material don't have to set the uniforms multiple times
        prevMat = mat;}
        
    //Get the texture coordinates of the given texture - This enables us to use textures that aren't a power of two
    tex = sprite_get_texture(SMF_textureList[| texInd[m]], 0);
    texUVs = texture_get_uvs(tex);
    
    //Note, texture_get_uvs doesn't seem to work in HTML5, and instead returns an undefined value! This is a temporary failsafe
    if is_undefined(texUVs[0]){
        texUVs = [0, 0];}
    shader_set_uniform_f(uni[SMF_uni.TexUVs], texUVs[0], texUVs[1], texture_get_width(tex), texture_get_height(tex));
    
    //Draw the model
    vertex_submit(modArray[m], modelIndex[| SMF_model.Kind], tex);
}
shader_reset();
gpu_set_cullmode(cullmode);