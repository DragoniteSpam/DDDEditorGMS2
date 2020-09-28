/// @description spart__init()
function spart__init() {
    /*
        Initializes the sPart system.
        This script is global in scope and does not need to be used anywhere.

        Script created by TheSnidr
        www.thesnidr.com
    */
    gml_pragma("global","spart__init()");

    //Create billboard particle format
    globalvar sPartFormat;
    vertex_format_begin();
    vertex_format_add_color();
    sPartFormat = vertex_format_end();

    //Create mesh particle format
    globalvar sPartMeshFormat;
    vertex_format_begin();
    vertex_format_add_color();
    vertex_format_add_color();
    sPartMeshFormat = vertex_format_end();

    //Create various data structures that the system needs
    globalvar sPartVertexBatchMap;
    sPartVertexBatchMap = ds_map_create();
    globalvar sPartUniformMap;
    sPartUniformMap = ds_map_create();
    globalvar sPartUniformGrid;
    sPartUniformGrid = ds_grid_create(sPartUni.Num, 3);
    globalvar sPartEmitterMeshMap;
    sPartEmitterMeshMap = ds_map_create();

    enum sPartSys{
        Dynamic,RegShader,SecShader,MeshShader,EmitterMeshShader,EmitterList,StepList,DeathList,StepEmitterList,DeathEmitterList,ActiveEmitterList,DrawCalls,ParticleNum,Time,PrevTime,BatchSizeArray,VertexBatchArray,TypeList,DynamicInterval,ColliderGrid,DynamicParticles,Num}
    enum sPartTyp{
        LifeMin, LifeMax,
        Spr, SprOrig, SprStretchRandomNum, SprAnimSpd,
        Speed,
        Size,
        Angle, AngleRel,
        Colour,        ColourType, 
        BlendEnable,BlendSrc,    BlendDst,    Zwrite,        AlphaTestRef,
        Dir,    DirRadial,    GravDir,
        StepNumber,    StepType,    DeathNumber,DeathType,
        MeshEnabled,MeshVbuff,    MeshMbuff,    MeshNumPerBatch,MeshRotAxis,MeshAmbientCol, MeshLightCol, MeshLightDir, CullMode,
        ParameterNum}
    enum sPartEmt{
        ID,PartSystem,CreationTime,LifeSpan,PartType,ParticlesPerStep,Sector,EmitterType,StartMat,EndMat,Shape,Distribution,Mesh,MeshOffset,MeshPartNum,Parent,TimeOfDeath}
    enum sPartEmitterType{
        None,Stream,Retired,Dynamic}
    enum sPartUni{
        batchInd,partNum,emStartMat,emEndMat,emLifeSpan,emShapeDistrBurstID,emPartsPerStep,emTimeAlive,emSector,emMeshOffset,
        partSprOrig,partSprAnimImgNum,partSprAnimSpd,partLife,partSize,partAngle,partAngleRel,partSpd,partDir,partDirRad,partGrav,partCol,partColType,
        parentPartLife, parentPartSpd, parentPartDir, parentPartGrav, parentPartDirRad, parentPartSpawnNum,  
        partMeshRotAxis,partMeshAmbCol,partMeshLightCol,partMeshLightDir,step,partAlphaTestRef,
        Num}
    enum sPartCollider{
        Triangle,Ellipsoid,Block}

#macro spart_shape_cube 0
#macro spart_shape_circle 1
#macro spart_shape_cylinder 2
#macro spart_shape_sphere 3

#macro spart_distr_linear ps_distr_linear
#macro spart_distr_gaussian ps_distr_gaussian
#macro spart_distr_invgaussian ps_distr_invgaussian

#macro sPartBurstNum 99999
#macro sPartEmitterMeshHeader 4950309 //Arbitrary 32-bit positive digit


}
