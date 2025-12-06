// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function spart_type() constructor
{
    sprite = -1;
    spriteOrigin = [0, 0];            //[x, y]
    spriteSettings = [0, 0, 0, 0];    //[animation speed, random, number]
    
    size = [32, 32, 0, 0];            //[min, max, incr, acc]
    sizeClamp = [0, 10]                //[clampMin, clampMax]
    speed = [0, 0, 0, 0]            //[min, max, incr, acc]
    dir = [0, 0, 1, 0];                //[x, y, z, vary]
    radial = false;
    gravity = [0, 0, 0];
    life = [0, 0];                    //[lifeMin, lifeMax]
    angle = [0, 0, 0, 0];            //[min, max, incr, acc]
    faceMovingDirection = false;
    colour = array_create(16, 1);    //<-- An array containing four colours and four alphas
    colourType = 1;
    
    //GPU settings
    blendSrc = bm_src_alpha;
    blendDst = bm_inv_src_alpha;
    blendEnable = true;
    alphaTestRef = 1 / 255;
    zwrite = true;
    cullMode = cull_counterclockwise;
    
    //Secondary particles
    stepNum = 0;
    stepType = -1;
    deathNum = 0;
    deathType = -1;
    
    //Mesh particles
    meshEnabled = false;
    
    /// @func setSprite(sprite, image_speed, random)
    static setSprite = function(spr, spd, rand)
    {
        /*
            Set image_speed to -1 to make the animation stretch throughout each particle's life span
        */
        var sprW = sprite_get_width(spr);
        var sprH = sprite_get_height(spr);
        var num = sprite_get_number(spr);
        spriteSettings[0] = spd;
        spriteSettings[1] = rand;
        spriteSettings[2] = num;
        spriteSettings[3] = 0; //Unused for the time being
        spriteOrigin[0] = - sprite_get_xoffset(spr) / sprW
        spriteOrigin[1] = - sprite_get_yoffset(spr) / sprH;
        
        if (!is_undefined(spSprMap[? spr]))
        {
            sprite = spSprMap[? spr];
        }
        else
        {
            //Create a new sprite from the given sprite, using a custom format that allows for animation
            gpu_set_zwriteenable(false);
            gpu_set_blendmode_ext(bm_one, bm_zero);
            var surfaceWidth = power(2, round(log2(sprW * num)));
            var surfaceHeight = power(2, round(log2(sprH)));
            var s = surface_create(surfaceWidth, surfaceHeight);
            surface_set_target(s);
            draw_clear_alpha(c_white, 0);
            for (var i = 0; i < num; i ++)
            {
                draw_sprite_stretched(spr, i, i / num * surfaceWidth, 0, surfaceWidth / num, surfaceHeight);
            }
            surface_reset_target();
            sprite = sprite_create_from_surface(s, 0, 0, surfaceWidth, surfaceHeight, 0, 0, 0, 0);
            surface_free(s);
            gpu_set_blendmode(bm_normal);
            
            spSprMap[? spr] = sprite;
        }
    }
    
    /// @func setLife(minLife, maxLife)
    static setLife = function(minLife, maxLife)
    {
        life[0] = minLife;
        life[1] = maxLife;
    }
    
    /// @func setSpeed(minStartSpeed, maxStartSpeed, acceleration, jerk)
    static setSpeed = function(minStartSpeed, maxStartSpeed, acceleration, jerk)
    {
        //Make sure the speed isn't 0
        if (minStartSpeed == 0){minStartSpeed = 0.00001;}
        if (maxStartSpeed == 0){maxStartSpeed = 0.00001;}
        speed[0] = minStartSpeed;
        speed[1] = maxStartSpeed;
        speed[2] = acceleration;
        speed[3] = jerk;
    }
    
    /// @func setDirection(xdir, ydir, zdir, angleVariation, radial)
    static setDirection = function(xdir, ydir, zdir, angleVariation, _radial)
    {
        /*
            Set the starting direction vector of the particles, as well as an angle (in degrees)
            that defines how far the particles may deviate from the starting direction.
            Setting radial to true modifies the starting direction to point away from the center of the emitter.
                Particles that have been emitted by other particles will ignore its own direction, 
                and instead keep moving in the direction of its creator, plus the direction variation

            Script created by TheSnidr
            www.thesnidr.com
        */
        var l = xdir * xdir + ydir * ydir + zdir * zdir;
        if (l != 0 && l != 1)
        {    //Normalize direction vector
            l = 1 / sqrt(l);
            xdir *= l;
            ydir *= l;
            zdir *= l;
        }
        dir[0] = xdir;
        dir[1] = ydir;
        dir[2] = zdir + (l == 0);
        dir[3] = degtorad(angleVariation);
        radial = _radial;
    }
    
    /// @func setGravity(gravity, xdir, ydir, zdir)
    static setGravity = function(magnitude, xdir, ydir, zdir)
    {
        var l = xdir * xdir + ydir * ydir + zdir * zdir;
        if (l != 0)
        {    //Normalize direction vector
            l = magnitude / sqrt(l);
        }
        gravity[0] = xdir * l;
        gravity[1] = ydir * l;
        gravity[2] = zdir * l;
    }
    
    /// @func setOrientation(minStartAngle, maxStartAngle, angleSpeed, angleAcceleration, relative)
    static setOrientation = function(minStartAngle, maxStartAngle, angleSpeed, angleAcceleration, relative)
    {
        angle[0] = degtorad(minStartAngle);
        angle[1] = degtorad(maxStartAngle);
        angle[2] = degtorad(angleSpeed);
        angle[3] = degtorad(angleAcceleration);
        faceMovingDirection = relative;
    }
    
    /// @func setSize(minStartSize, maxStartSize, sizeSpeed, sizeAcceleration, clampMin, clampMax)
    static setSize = function(minStartSize, maxStartSize, sizeSpeed, sizeAcceleration, clampMin, clampMax)
    {
        size[0] = minStartSize;
        size[1] = maxStartSize;
        size[2] = sizeSpeed;
        size[3] = sizeAcceleration;
        sizeClamp[0] = clampMin;
        sizeClamp[1] = clampMax;
    }
    
    /// @func setBlend(enableBlending, additive)
    static setBlend = function(enableBlending, additive)
    {
        zwrite = !additive;
        blendEnable = enableBlending;
        blendSrc = bm_src_alpha;
        blendDst = additive ? bm_one : bm_inv_src_alpha;
    }
    
    /// @func setBlendExt(src, dest, zwrite)
    static setBlendExt = function(src, dest, _zwrite)
    {
        zwrite = _zwrite;
        blendEnable = true;
        blendSrc = src;
        blendDst = dest;
    }
    
    /// @func setAlphaTestRef(value 0-256)
    static setAlphaTestRef = function(val)
    {
        alphaTestRef = clamp(val / 255, 0, 1);
    }
    
    /// @func setColour(col1, alpha1, col2*, alpha2*, col3*, alpha3*, col4*, alpha4*, choose*)
    static setColour = function(col1, alpha1, col2, alpha2, col3, alpha3, col4, alpha4, _choose)
    {
        /*
            Give the particle type one, two, three or four colours and a corresponding number of alphas.
            If choose is true, it will select a random one of the given colours for the whole of the particle's life span
            If choose is false, it will smoothly interpolate between the given colours through the particle's life span
        */
        var i = 0;
        var j = 0;
        colourType = 0;
        repeat 4
        {
            if (is_undefined(argument[j])){break;}
            var col = argument[j ++];
            colour[i++] = color_get_red(col) / 255;
            colour[i++] = color_get_green(col) / 255;
            colour[i++] = color_get_blue(col) / 255;
            colour[i++] = argument[j++];
            colourType ++;
        }
        if (!is_undefined(_choose))
        {
            if (_choose){colourType = 0;}
        }
    }
    
    /// @func setStep(type, num)
    static setStep = function(type, num)
    {
        /*
            Enables particle trails by making each particle emit a given number of particles per unit of time.
            Note that this effect does not stack, child particles can not spawn particles of their own.

            Script created by TheSnidr
            www.thesnidr.com
        */
        if (type.meshEnabled)
        {
            show_error("Error in script spart_type.setStep: Mesh particles cannot be secondary particles", false);
            exit;
        }
        stepNumber = num;
        stepType = type;
    }
    
    /// @func setDeath(type, num)
    static setDeath = function(type, num)
    {
        /*
            Enables particle trails by making each particle emit a given number of particles per unit of time.
            Note that this effect does not stack, child particles can not spawn particles of their own.

            Script created by TheSnidr
            www.thesnidr.com
        */
        if (type.meshEnabled)
        {
            show_error("Error in script spart_type.setStep: Mesh particles cannot be secondary particles", false);
            exit;
        }
        deathNumber = num;
        deathType = type;
    }
    
    /// @func setMesh(mesh, numPerBatch)
    static setMesh = function(mesh, numPerBatch) 
    {
        /*
            Lets you draw 3D meshes as particles. The meshes will be simulated in the same way as the billboarded particles, 
            but will be drawn in full 3D and not in view-space.
            Model can be an index of a buffer, a path to an .obj model or a path to a buffer.
            If a buffer is supplied, it must be formatted in the following way:
                3D position,        3x4 bytes
                Normal                3x4 bytes
                Texture coordinates    2x4 bytes
                Colour                4x1 bytes

            Script created by TheSnidr
            www.thesnidr.com
        */
        //If the argument is a string, assume the user is trying to load an external file
        var load = false;
        if (is_string(mesh))
        {
            load = true;
            mesh = spart_load_obj_to_buffer(mesh);
        }
        if (is_array(mesh))
        {
            load = true;
            var _mesh = buffer_create(1, buffer_fixed, 1);
            var num = array_length(mesh);
            var totalSize = 0;
            for (var i = 0; i < num; i ++) 
            {
                var buffSize = buffer_get_size(mesh[i]);
                var buffPos = totalSize;
                totalSize += buffSize;
                buffer_resize(mesh, totalSize);
                buffer_copy(mesh[i], 0, buffSize, mesh, buffPos);
            }
            mesh = _mesh;
        }
        if (mesh < 0)
        {
            return false;
        }
        
        if (meshEnabled)
        {    //If a mesh vbuff exists, delete it
            vertex_delete_buffer(meshVbuff);
        }
        meshEnabled = true;
        meshNumPerBatch = clamp(numPerBatch, 0, 255); //The number of particles per batch cannot exceed 255 for mesh particles
        meshAmbientCol = [.5, .5, .5];
        meshLightCol = [1, 1, 1];
        meshLightDir = [0, 0, -1];
        meshRotAxis = [0, 0, 1];
        var bytesPerVert = 3 * 4 + 3 * 4 + 2 * 4 + 4 * 1;
        var vertNum = buffer_get_size(mesh) / bytesPerVert;
        var mBuff = buffer_create(8 * vertNum * meshNumPerBatch, buffer_fixed, 1);

        //Find the outer boundaries of the vertex buffer
        var Min = [9999999, 9999999, 9999999];
        var Max = [-9999999, -9999999, -9999999];
        for (var i = 0; i < vertNum; i ++)
        {
            buffer_seek(mesh, buffer_seek_start, i * bytesPerVert);
            for (var j = 0; j < 3; j ++)
            {
                var v = buffer_read(mesh, buffer_f32);
                Min[j] = min(Min[j], v);
                Max[j] = max(Max[j], v);
            }
        }
        var size = max(Max[0] - Min[0], Max[1] - Min[1], Max[2] - Min[2]);
        var offsetx = (Min[0] + Max[0]) / 2;
        var offsety = (Min[1] + Max[1]) / 2;
        var offsetz = (Min[2] + Max[2]) / 2;
        buffer_seek(mesh, buffer_seek_start, 0);
        for (var i = 0; i < vertNum; i ++)
        {
            //Read vertex info
            buffer_seek(mesh, buffer_seek_start, i * bytesPerVert);
            var vx = buffer_read(mesh, buffer_f32);
            var vy = buffer_read(mesh, buffer_f32);
            var vz = buffer_read(mesh, buffer_f32);
            var nx = buffer_read(mesh, buffer_f32);
            var ny = buffer_read(mesh, buffer_f32);
            var nz = buffer_read(mesh, buffer_f32);
            var tu = buffer_read(mesh, buffer_f32);
            var tv = buffer_read(mesh, buffer_f32);
    
            //Encode vertex info
            vx = 255 * (0.5 + (vx - offsetx) / size);
            vy = 255 * (0.5 + (vy - offsety) / size);
            vz = 255 * (0.5 + (vz - offsetz) / size);
            tu = clamp(round(tu * 255), 0, 255);
            tv = clamp(round(tv * 255), 0, 255);
            normalxyAngle = floor(255 * point_direction(0, 0, nx, ny) / 360);
            normalzAngle = floor(255 * point_direction(0, 0, nz, -point_distance(0, 0, nx, ny)) / 180);
    
            //Write vertex info multiple times to the target buffer
            for (var j = 0; j < meshNumPerBatch; j ++)
            {
                buffer_seek(mBuff, buffer_seek_start, (i + j * vertNum) * 8);
        
                //Vertex position
                buffer_write(mBuff, buffer_u8, vx);
                buffer_write(mBuff, buffer_u8, vy);
                buffer_write(mBuff, buffer_u8, vz);
                
                //Particle index
                buffer_write(mBuff, buffer_u8, j);
                
                //Texture coords
                buffer_write(mBuff, buffer_u8, tu);
                buffer_write(mBuff, buffer_u8, tv);
                
                //Encode normals into two bytes
                buffer_write(mBuff, buffer_u8, normalxyAngle);
                buffer_write(mBuff, buffer_u8, normalzAngle);
            }
        }

        meshVbuff = vertex_create_buffer_from_buffer(mBuff, global.sPartMeshFormat);
        buffer_delete(mBuff);
        vertex_freeze(meshVbuff);
        ds_list_add(spMeshes, meshVbuff);
        
        //If a new buffer was created in this script, delete the buffer
        if (load)
        {
            buffer_delete(mesh);
        }
    }
    
    /// @func setMeshLighting(ambientCol, lightCol, ldirX, ldirY, ldirZ)
    static setMeshLighting = function(ambientCol, lightCol, ldirX, ldirY, ldirZ)
    {
        var l = ldirX * ldirX + ldirY * ldirY + ldirZ * ldirZ;
        if (l != 0 && l != 1)
        {
            l = 1 / sqrt(l);
            ldirX *= l;
            ldirY *= l;
            ldirZ *= l;
        }
        meshLightDir = [ldirX, ldirY, ldirZ];
        meshLightCol = [color_get_red(lightCol) / 255, color_get_green(lightCol) / 255, color_get_blue(lightCol) / 255];
        meshAmbientCol = [color_get_red(ambientCol) / 255, color_get_green(ambientCol) / 255, color_get_blue(ambientCol) / 255];
    }
    
    /// @func setMeshRotationAxis(x, y, z, axisDeviation)
    static setMeshRotationAxis = function(ax, ay, az, angle)
    {
        /*
            Enables mesh rotation about a given axis.
            The axis may deviate from the given axis by axisDeviation degrees.
            Setting axisDeviation to 0 will make all particles rotate about the same
            axis, while setting it to 360 will make their rotation axes totally random.

            The rotation angle speeds are set in spart_type.setOrientation

            Script created by TheSnidr
            www.thesnidr.com
        */
        var l = ax * ax + ay * ay + az * az;
        if (l != 0 && l != 1)
        {
            l = 1 / sqrt(l);
            ax *= l;
            ay *= l;
            az *= l;
        }
        meshRotAxis = [ax, ay, az, degtorad(angle)];
    }
    
    /// @func setMeshCullmode(mode)
    static setMeshCullmode = function(mode)
    {
        cullMode = mode;
    }
    
    /// @func setUniforms(uniInd)
    static setUniforms = function(uniInd)
    {
        //Set GPU settings
        gpu_set_cullmode(cullMode);
        gpu_set_zwriteenable(zwrite);
        gpu_set_blendenable(blendEnable);
        if (blendEnable)
        {
            gpu_set_blendmode_ext(blendSrc, blendDst);
        }
    
        shader_set_uniform_f(spUniGrid[# sPartUni.partLife, uniInd], life[0], life[1]);
        shader_set_uniform_f_array(spUniGrid[# sPartUni.partSprSettings, uniInd], spriteSettings);
        shader_set_uniform_f(spUniGrid[# sPartUni.partSprOrig, uniInd], spriteOrigin[0], spriteOrigin[1]);
        shader_set_uniform_f_array(spUniGrid[# sPartUni.partGrav, uniInd], gravity);
        shader_set_uniform_f_array(spUniGrid[# sPartUni.partAngle, uniInd], angle);
        shader_set_uniform_f_array(spUniGrid[# sPartUni.partCol, uniInd], colour);
        shader_set_uniform_f_array(spUniGrid[# sPartUni.partSize, uniInd], size);
        shader_set_uniform_f_array(spUniGrid[# sPartUni.partSizeClamp, uniInd], sizeClamp);
        shader_set_uniform_f_array(spUniGrid[# sPartUni.partSpd, uniInd], speed);
        shader_set_uniform_f_array(spUniGrid[# sPartUni.partDir, uniInd], dir);
        shader_set_uniform_i(spUniGrid[# sPartUni.partAngleRel, uniInd], faceMovingDirection);
        shader_set_uniform_i(spUniGrid[# sPartUni.partDirRad, uniInd], radial);
        shader_set_uniform_f(spUniGrid[# sPartUni.partColType, uniInd], colourType);
        shader_set_uniform_f(spUniGrid[# sPartUni.partAlphaTestRef, uniInd], alphaTestRef);

        if (meshEnabled)
        {
            shader_set_uniform_f_array(spUniGrid[# sPartUni.partMeshRotAxis, uniInd], meshRotAxis);
            shader_set_uniform_f_array(spUniGrid[# sPartUni.partMeshAmbCol, uniInd], meshAmbientCol);
            shader_set_uniform_f_array(spUniGrid[# sPartUni.partMeshLightCol, uniInd], meshLightCol);
            shader_set_uniform_f_array(spUniGrid[# sPartUni.partMeshLightDir, uniInd], meshLightDir);
        }
    }
    
    /// @func setParentUniforms(uniInd, step (true or false))
    static setParentUniforms = function(uniInd, step)
    {
        shader_set_uniform_i(spUniGrid[# sPartUni.step, uniInd], step);
        shader_set_uniform_f_array(spUniGrid[# sPartUni.parentPartLife, uniInd], life);
        shader_set_uniform_f_array(spUniGrid[# sPartUni.parentPartSpd, uniInd], speed);
        shader_set_uniform_f_array(spUniGrid[# sPartUni.parentPartDir, uniInd], dir);
        shader_set_uniform_f_array(spUniGrid[# sPartUni.parentPartGrav, uniInd], gravity);
        shader_set_uniform_i(spUniGrid[# sPartUni.parentPartDirRad, uniInd], radial);
        shader_set_uniform_f(spUniGrid[# sPartUni.parentPartSpawnNum, uniInd], step ? stepNumber : deathNumber);
    }
}