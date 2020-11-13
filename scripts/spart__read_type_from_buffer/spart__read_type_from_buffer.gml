/// @description spart__read_type_from_buffer(buffer, partSystem)
/// @param buffer
/// @param partSystem
function spart__read_type_from_buffer(argument0, argument1) {
    /*
        Reads a particle type from a buffer.

        Script created by TheSnidr
        www.thesnidr.com
    */
    var loadBuff = argument0;
    var partSystem = argument1;

    var partType = spart_type_create(partSystem);

    //Sprite animation
    partType[| sPartTyp.SprStretchRandomNum] = buffer_read(loadBuff, buffer_f32);
    partType[| sPartTyp.SprAnimSpd] = buffer_read(loadBuff, buffer_f32);

    //Scale
    var size = array_create(4);
    size[0] = buffer_read(loadBuff, buffer_f32);
    size[1] = buffer_read(loadBuff, buffer_f32);
    size[2] = buffer_read(loadBuff, buffer_f32);
    size[3] = buffer_read(loadBuff, buffer_f32);
    partType[| sPartTyp.Size] = size;

    //Speed
    var spd = array_create(4);
    spd[0] = buffer_read(loadBuff, buffer_f32);
    spd[1] = buffer_read(loadBuff, buffer_f32);
    spd[2] = buffer_read(loadBuff, buffer_f32);
    spd[3] = buffer_read(loadBuff, buffer_f32);
    partType[| sPartTyp.Speed] = spd;

    //Direction
    var dir = array_create(5);
    dir[0] = buffer_read(loadBuff, buffer_f32);
    dir[1] = buffer_read(loadBuff, buffer_f32);
    dir[2] = buffer_read(loadBuff, buffer_f32);
    dir[4] = buffer_read(loadBuff, buffer_f32);
    partType[| sPartTyp.Dir] = dir;
    partType[| sPartTyp.DirRadial] = buffer_read(loadBuff, buffer_bool);

    //Gravity
    var dir = array_create(3);
    dir[0] = buffer_read(loadBuff, buffer_f32);
    dir[1] = buffer_read(loadBuff, buffer_f32);
    dir[2] = buffer_read(loadBuff, buffer_f32);
    partType[| sPartTyp.GravDir] = dir;

    //Life
    partType[| sPartTyp.LifeMin] = buffer_read(loadBuff, buffer_f32);
    partType[| sPartTyp.LifeMax] = buffer_read(loadBuff, buffer_f32);

    //Angle
    var ang = array_create(4);
    ang[0] = buffer_read(loadBuff, buffer_f32);
    ang[1] = buffer_read(loadBuff, buffer_f32);
    ang[2] = buffer_read(loadBuff, buffer_f32);
    ang[3] = buffer_read(loadBuff, buffer_f32);
    partType[| sPartTyp.Angle] = ang;
    partType[| sPartTyp.AngleRel] = buffer_read(loadBuff, buffer_bool);

    //Colour
    var col = array_create(16);
    for (var i = 0; i < 16; i ++)
    {
        col[i] = buffer_read(loadBuff, buffer_f32);
    }
    partType[| sPartTyp.Colour] = col;
    partType[| sPartTyp.ColourType] = buffer_read(loadBuff, buffer_u8);

    //Blend mode
    partType[| sPartTyp.BlendSrc] = buffer_read(loadBuff, buffer_u8);
    partType[| sPartTyp.BlendDst] = buffer_read(loadBuff, buffer_u8);
    partType[| sPartTyp.Zwrite] = buffer_read(loadBuff, buffer_bool);

    //Mesh
    partType[| sPartTyp.MeshEnabled] = buffer_read(loadBuff, buffer_bool);

    if partType[| sPartTyp.MeshEnabled]
    {
        //Mesh vertex buffer
        var buffSize = buffer_read(loadBuff, buffer_u32);
        partType[| sPartTyp.MeshMbuff] = buffer_create(buffSize, buffer_fixed, 1);
        buffer_copy(loadBuff, buffer_tell(loadBuff), buffSize, partType[| sPartTyp.MeshMbuff], 0);
        buffer_seek(loadBuff, buffer_seek_relative, buffSize);
        partType[| sPartTyp.MeshVbuff] = vertex_create_buffer_from_buffer(partType[| sPartTyp.MeshMbuff], sPartMeshFormat);
        vertex_freeze(partType[| sPartTyp.MeshVbuff]);

        //Mesh settings
        partType[| sPartTyp.MeshNumPerBatch] = buffer_read(loadBuff, buffer_u8);
        partType[| sPartTyp.CullMode] = buffer_read(loadBuff, buffer_u8);
    
        //Mesh rotation axis
        var axis = array_create(3);
        axis[0] = buffer_read(loadBuff, buffer_f32);
        axis[1] = buffer_read(loadBuff, buffer_f32);
        axis[2] = buffer_read(loadBuff, buffer_f32);
        partType[| sPartTyp.MeshRotAxis] = axis;
    
        //Mesh ambient colour
        var col = array_create(4);
        col[0] = buffer_read(loadBuff, buffer_f32);
        col[1] = buffer_read(loadBuff, buffer_f32);
        col[2] = buffer_read(loadBuff, buffer_f32);
        partType[| sPartTyp.MeshAmbientCol] = col;
    
        //Mesh light colour
        var col = array_create(4);
        col[0] = buffer_read(loadBuff, buffer_f32);
        col[1] = buffer_read(loadBuff, buffer_f32);
        col[2] = buffer_read(loadBuff, buffer_f32);
        partType[| sPartTyp.MeshLightCol] = col;
    
        //Mesh light direction
        var dir = array_create(3);
        dir[0] = buffer_read(loadBuff, buffer_f32);
        dir[1] = buffer_read(loadBuff, buffer_f32);
        dir[2] = buffer_read(loadBuff, buffer_f32);
        partType[| sPartTyp.MeshLightDir] = dir;
    }

    //Sprite
    var sprOrig = array_create(2);
    sprOrig[0] = buffer_read(loadBuff, buffer_f32);
    sprOrig[1] = buffer_read(loadBuff, buffer_f32);
    partType[| sPartTyp.SprOrig] = sprOrig;

    if buffer_read(loadBuff, buffer_bool)
    {
        var w = buffer_read(loadBuff, buffer_u16);
        var h = buffer_read(loadBuff, buffer_u16);
    
        var sprBuff = buffer_create(w * h * 4, buffer_fixed, 1);
        buffer_copy(loadBuff, buffer_tell(loadBuff), w * h * 4, sprBuff, 0);
        buffer_seek(loadBuff, buffer_seek_relative, w * h * 4);
    
        var surface = surface_create(w, h);
        buffer_set_surface(sprBuff, surface, 0);
        buffer_delete(sprBuff);
        partType[| sPartTyp.Spr] = sprite_create_from_surface(surface, 0, 0, w, h, 0, 0, 0, 0);
        surface_free(surface);
    }

    //Secondary particles
    partType[| sPartTyp.StepNumber] = buffer_read(loadBuff, buffer_u16);
    if partType[| sPartTyp.StepNumber]
    {
        partType[| sPartTyp.StepType] = spart__read_type_from_buffer(loadBuff, partSystem);
    }
    partType[| sPartTyp.DeathNumber] = buffer_read(loadBuff, buffer_u16);
    if partType[| sPartTyp.DeathNumber]
    {
        partType[| sPartTyp.DeathType] = spart__read_type_from_buffer(loadBuff, partSystem);
    }

    return partType;


}
