/// @description spart__write_type_to_buffer(buffer, partType, depth)
/// @param buffer
/// @param partType
function spart__write_type_to_buffer(argument0, argument1, argument2) {
    /*
        Saves a particle type to a buffer.
        This script writes everything - Settings, sprites, meshes and step/death particle types.

        Script created by TheSnidr
        www.thesnidr.com
    */
    var saveBuff = argument0;
    var partType = argument1;
    var dpth = argument2;
    if dpth > 1{exit;}

    //Sprite animation
    buffer_write(saveBuff, buffer_f32, partType[| sPartTyp.SprStretchRandomNum]);
    buffer_write(saveBuff, buffer_f32, partType[| sPartTyp.SprAnimSpd]);

    //Size
    var size = partType[| sPartTyp.Size];
    buffer_write(saveBuff, buffer_f32, size[0]);
    buffer_write(saveBuff, buffer_f32, size[1]);
    buffer_write(saveBuff, buffer_f32, size[2]);
    buffer_write(saveBuff, buffer_f32, size[3]);

    //Speed
    var spd = partType[| sPartTyp.Speed];
    buffer_write(saveBuff, buffer_f32, spd[0]);
    buffer_write(saveBuff, buffer_f32, spd[1]);
    buffer_write(saveBuff, buffer_f32, spd[2]);
    buffer_write(saveBuff, buffer_f32, spd[3]);

    //Direction
    var dir = partType[| sPartTyp.Dir];
    buffer_write(saveBuff, buffer_f32, dir[0]);
    buffer_write(saveBuff, buffer_f32, dir[1]);
    buffer_write(saveBuff, buffer_f32, dir[2]);
    buffer_write(saveBuff, buffer_f32, dir[3]);
    buffer_write(saveBuff, buffer_bool, partType[| sPartTyp.DirRadial]);

    //Gravity
    var grav = partType[| sPartTyp.GravDir];
    buffer_write(saveBuff, buffer_f32, grav[0]);
    buffer_write(saveBuff, buffer_f32, grav[1]);
    buffer_write(saveBuff, buffer_f32, grav[2]);

    //Life
    buffer_write(saveBuff, buffer_f32, partType[| sPartTyp.LifeMin]);
    buffer_write(saveBuff, buffer_f32, partType[| sPartTyp.LifeMax]);

    //Angle
    var ang = partType[| sPartTyp.Angle];
    buffer_write(saveBuff, buffer_f32, ang[0]);
    buffer_write(saveBuff, buffer_f32, ang[1]);
    buffer_write(saveBuff, buffer_f32, ang[2]);
    buffer_write(saveBuff, buffer_f32, ang[3]);
    buffer_write(saveBuff, buffer_bool, partType[| sPartTyp.AngleRel]);

    //Colour
    var col = partType[| sPartTyp.Colour];
    for (var i = 0; i < 16; i ++)
    {
        buffer_write(saveBuff, buffer_f32, col[i]);
    }
    buffer_write(saveBuff, buffer_u8, partType[| sPartTyp.ColourType]);

    //Blend mode
    buffer_write(saveBuff, buffer_u8, partType[| sPartTyp.BlendSrc]);
    buffer_write(saveBuff, buffer_u8, partType[| sPartTyp.BlendDst]);
    buffer_write(saveBuff, buffer_bool, partType[| sPartTyp.Zwrite]);

    //Mesh
    buffer_write(saveBuff, buffer_bool, partType[| sPartTyp.MeshEnabled]);

    if partType[| sPartTyp.MeshEnabled]
    {
        //Mesh vertex buffer
        var buffSize = buffer_get_size(partType[| sPartTyp.MeshMbuff]);
        buffer_write(saveBuff, buffer_u32, buffSize);
        buffer_copy(partType[| sPartTyp.MeshMbuff], 0, buffSize, saveBuff, buffer_tell(saveBuff));
        buffer_seek(saveBuff, buffer_seek_relative, buffSize);
    
        //Mesh settings
        buffer_write(saveBuff, buffer_u8, partType[| sPartTyp.MeshNumPerBatch]);
        buffer_write(saveBuff, buffer_u8, partType[| sPartTyp.CullMode]);
    
        //Mesh rotation axis
        var axis = partType[| sPartTyp.MeshRotAxis];
        buffer_write(saveBuff, buffer_f32, axis[0]);
        buffer_write(saveBuff, buffer_f32, axis[1]);
        buffer_write(saveBuff, buffer_f32, axis[2]);

        //Mesh ambient colour
        var col = partType[| sPartTyp.MeshAmbientCol];
        buffer_write(saveBuff, buffer_f32, col[0]);
        buffer_write(saveBuff, buffer_f32, col[1]);
        buffer_write(saveBuff, buffer_f32, col[2]);

        //Mesh light colour
        var col = partType[| sPartTyp.MeshLightCol];
        buffer_write(saveBuff, buffer_f32, col[0]);
        buffer_write(saveBuff, buffer_f32, col[1]);
        buffer_write(saveBuff, buffer_f32, col[2]);

        //Mesh light direction
        var dir = partType[| sPartTyp.MeshLightDir];
        buffer_write(saveBuff, buffer_f32, dir[0]);
        buffer_write(saveBuff, buffer_f32, dir[1]);
        buffer_write(saveBuff, buffer_f32, dir[2]);
    }

    //Sprite
    var sprOrig = partType[| sPartTyp.SprOrig];
    buffer_write(saveBuff, buffer_f32, sprOrig[0]);
    buffer_write(saveBuff, buffer_f32, sprOrig[1]);

    var spr = partType[| sPartTyp.Spr];
    buffer_write(saveBuff, buffer_bool, sprite_exists(spr));
    if sprite_exists(spr)
    {
        var w = sprite_get_width(spr);
        var h = sprite_get_height(spr);
        buffer_write(saveBuff, buffer_u16, w);
        buffer_write(saveBuff, buffer_u16, h);
    
        gpu_set_zwriteenable(false);
        gpu_set_blendmode_ext(bm_one, bm_zero);
        var surface = surface_create(w, h);
        surface_set_target(surface);
        draw_clear_alpha(c_white, 0);
        draw_sprite(spr, 0, 0, 0);
        surface_reset_target();
        gpu_set_blendmode(bm_normal);
    
        var sprBuff = buffer_create(w * h * 4, buffer_grow, 1);
        buffer_get_surface(sprBuff, surface, 0);
        buffer_copy(sprBuff, 0, w * h * 4, saveBuff, buffer_tell(saveBuff));
        buffer_seek(saveBuff, buffer_seek_relative, w * h * 4);
        buffer_delete(sprBuff);
        surface_free(surface);
    }

    //Secondary particles
    if dpth
    {
        buffer_write(saveBuff, buffer_u16, 0);
        buffer_write(saveBuff, buffer_u16, 0);
    }
    else
    {
        buffer_write(saveBuff, buffer_u16, partType[| sPartTyp.StepNumber]);
        if partType[| sPartTyp.StepNumber] > 0
        {
            spart__write_type_to_buffer(saveBuff, partType[| sPartTyp.StepType], 1);
        }
        buffer_write(saveBuff, buffer_u16, partType[| sPartTyp.DeathNumber]);
        if partType[| sPartTyp.DeathNumber] > 0
        {
            spart__write_type_to_buffer(saveBuff, partType[| sPartTyp.DeathType], 1);
        }
    }


}
