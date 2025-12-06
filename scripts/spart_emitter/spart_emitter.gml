// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
enum sPartEmitterType
{
    None, Stream, Retired, Dynamic
}

#macro spart_shape_cube 0
#macro spart_shape_circle 1
#macro spart_shape_cylinder 2
#macro spart_shape_sphere 3

#macro spart_distr_linear ps_distr_linear
#macro spart_distr_gaussian ps_distr_gaussian
#macro spart_distr_invgaussian ps_distr_invgaussian
        
        

#macro sPartBurstNum 99999
/// @func spart_emitter(partSystem)
function spart_emitter(_partSystem) constructor
{
    ID = random(256 * 256);
    partSystem = _partSystem;
    type = sPartEmitterType.None;
    
    startM = matrix_build_identity();
    endM = matrix_build_identity();
    
    sector = 360;
    shape = spart_shape_sphere;
    distribution = spart_distr_linear;
    
    mesh = -1;
    meshPartNum = 0;
    
    parent = -1;
    partType = -1;
    particlesPerStep = 0;
    
    lifeSpan = 9999999;
    creationTime = partSystem.time;
    timeOfDeath = creationTime + lifeSpan;
    
    ds_list_add(partSystem.emitterList, self);
    
    /// @func destroy()
    static destroy = function()
    {
        //Delete from active emitters list
        var ind = ds_list_find_index(partSystem.activeEmitterList, self);
        if (ind >= 0)
        {
            ds_list_delete(partSystem.activeEmitterList, ind-1);
            ds_list_delete(partSystem.activeEmitterList, ind-1);
        }
        
        //Delete from active emitters list
        var ind = ds_list_find_index(partSystem.stepEmitterList, self);
        if (ind >= 0)
        {
            ds_list_delete(partSystem.stepEmitterList, ind-1);
            ds_list_delete(partSystem.stepEmitterList, ind-1);
        }
        
        //Delete from active emitters list
        var ind = ds_list_find_index(partSystem.deathEmitterList, self);
        if (ind >= 0)
        {
            ds_list_delete(partSystem.deathEmitterList, ind-1);
            ds_list_delete(partSystem.deathEmitterList, ind-1);
        }
        
        //Delete from emitter list
        var ind = ds_list_find_index(partSystem.emitterList, self);
        if (ind >= 0)
        {
            ds_list_delete(partSystem.emitterList, ind);
        }
    }
    
    /// @func stream(partType, partsPerStep, lifeSpan, dynamic)
    static stream = function(_partType, _partsPerStep, _lifeSpan, dynamic)
    {
        if (dynamic)
        {
            if (retire(false))
            {
                creationTime = partSystem.time;
                startM = endM;
                ID = irandom(256);
            }
        }
        partType = _partType;
        particlesPerStep = _partsPerStep;
        lifeSpan = (_lifeSpan > 0 ? _lifeSpan : 9999999); //If lifeSpan is negative, set the life span of the emitter to an arbitrary high number
        type = sPartEmitterType.Stream;
        activate();
    }
    
    /// @func burst(partType, number, dynamic)
    function burst(_partType, _number, dynamic) 
    {
        //Makes the emitter emit only the given number of particles all at once, before becoming inactive.
        if (dynamic)
        {
            retire(true);
        }

        startM = endM;
        partType = _partType;
        ID = random(256 * 256);
        type = sPartEmitterType.Stream;
        creationTime = partSystem.time;
        particlesPerStep = sPartBurstNum; 
        lifeSpan = _number / particlesPerStep;
        activate();
    }

    
    /// @func activate()
    static activate = function()
    {
        if (!is_struct(partType)){exit;}
        
        //Make sure the emitter is on the active emitters list
        var list = partSystem.activeEmitterList;
        if (ds_list_find_index(list, self) < 0)
        {
            var ind = max(0, ds_list_find_index(list, partType));
            ds_list_insert(list, ind, self);
            ds_list_insert(list, ind, partType);
        }
        
        //Make sure the emitter is on the step emitters list if its particle type has a step particle
        var stepType = partType.stepType;
        if (is_struct(stepType))
        {
            var list = partSystem.stepEmitterList;
            if (ds_list_find_index(list, self) < 0)
            {
                var ind = max(0, ds_list_find_index(list, stepType));
                ds_list_insert(list, ind, self);
                ds_list_insert(list, ind, stepType);
            }
        }
        
        //Make sure the emitter is on the step emitters list if its particle type has a step particle
        var deathType = partType.deathType;
        if (is_struct(deathType))
        {
            var list = partSystem.deathEmitterList;
            if (ds_list_find_index(list, self) < 0)
            {
                var ind = max(0, ds_list_find_index(list, deathType));
                ds_list_insert(list, ind, self);
                ds_list_insert(list, ind, deathType);
            }
        }
    }
    
    /// @func setRegion(M, xscale, yscale, zscale, shape, distribution, dynamic)
    static setRegion = function(M, xscale, yscale, zscale, _shape, _distribution, dynamic)
    {
        if !(spart_matrix_orthogonalize(M))
        {
            show_debug_message("ERROR in spart_emitter.setRegion: Illegal matrix");
            return false;
        }
        if (xscale == 0){xscale = .00001;}
        if (yscale == 0){yscale = .00001;}
        if (zscale == 0){zscale = .00001;}
        spart_matrix_scale(M, xscale, yscale, zscale);
        if (dynamic)
        {
            if (retire(false))
            {
                creationTime = partSystem.time;
                startM = endM;
                ID = irandom(256);
            }
        }
        else
        {
            startM = M;
        }
        endM = M;
        shape = _shape;
        distribution = _distribution;
        activate();
    }
    
    /// @func mature()
    static mature = function()
    {
        /*
            Maturing an emitter will make it seem like it has been emitting for a long time, even if it was just created.
        */
        if (!is_struct(partType))
        {
            exit;
        }
        creationTime -= partType.life[1];
        var stepType = partType.stepType;
        if is_struct(stepType)
        {
            creationTime -= stepType.life[1];
        }
        var deathType = partType.deathType;
        if is_struct(deathType)
        {
            creationTime -= deathType.life[1];
        }
    }
    
    /// @func retire(force)
    static retire = function(force)
    {
        if (type != sPartEmitterType.Stream)
        {
            return true;
        }
        if (!force && partSystem.time < creationTime + min(lifeSpan, partSystem.dynamicInterval))
        {
            return false;
        }
        
        //Create a duplicate of the emitter, and retire that
        var retired = new spart_emitter(partSystem);
        retired.type = sPartEmitterType.Retired;
        retired.ID = ID;
        array_copy(retired.startM, 0, startM, 0, 16);
        array_copy(retired.endM, 0, endM, 0, 16);
        retired.sector = sector;
        retired.shape = shape;
        retired.distribution = distribution;
        retired.mesh = mesh;
        retired.meshPartNum = meshPartNum;
        retired.parent = self;
        retired.partType = partType;
        retired.particlesPerStep = particlesPerStep;
        retired.lifeSpan = min(lifeSpan, partSystem.time - creationTime);
        retired.creationTime = creationTime;
        retired.timeOfDeath = creationTime + retired.lifeSpan + partType.life[1];
        if (is_struct(partType.stepType))
        {
            retired.timeOfDeath += partType.stepType.life[1];
        }
        if (is_struct(partType.deathType))
        {
            retired.timeOfDeath += partType.deathType.life[1];
        }
        
        //Replace the emitter with the retired emitter
        var ind = ds_list_find_index(partSystem.activeEmitterList, self);
        if (ind >= 0)
        {
            partSystem.activeEmitterList[| ind] = retired;
            var ind = ds_list_find_index(partSystem.stepEmitterList, self);
            if (ind >= 0)
            {
                partSystem.stepEmitterList[| ind] = retired;
            }
            var ind = ds_list_find_index(partSystem.deathEmitterList, self);
            if (ind >= 0)
            {
                partSystem.deathEmitterList[| ind] = retired;
            }
        }
        return true;
    }
    
    /// @func setUniforms(uniInd)
    static setUniforms = function(uniInd) 
    {
        /*
            Sets the uniforms for the emitter
    
            Script created by TheSnidr
            www.TheSnidr.com
        */
        var i = uniInd;
        var time = partSystem.time - creationTime;
        shader_set_uniform_f_array(spUniGrid[# sPartUni.emStartMat, i],    startM);
        shader_set_uniform_f_array(spUniGrid[# sPartUni.emEndMat, i], endM);
        shader_set_uniform_f(spUniGrid[# sPartUni.emLifeSpan, i], min(time, lifeSpan));
        shader_set_uniform_f(spUniGrid[# sPartUni.emTimeAlive, i], time);
        shader_set_uniform_f(spUniGrid[# sPartUni.emShapeDistrBurst, i], shape + 4 * distribution + 12 * (particlesPerStep != sPartBurstNum)); //<-- shape ranges from 0 to 3, distribution ranges from 0 to 2
        shader_set_uniform_f(spUniGrid[# sPartUni.emID, i], ID);
        shader_set_uniform_f(spUniGrid[# sPartUni.emPartsPerStep, i], particlesPerStep);
        shader_set_uniform_f(spUniGrid[# sPartUni.emSector, i], pi * sector / 360);
    }
    
    /// @func subdmit(type, uniInd, partNum)
    static submit = function(type, uniInd, partNum)
    {
        var tex = sprite_get_texture(type.sprite, 0);
        setUniforms(uniInd);
        partSystem.particleNum += partNum;

        //If the particle type is a mesh particle
        if (type.meshEnabled)
        {
            var vbuff = type.meshVbuff;
            var particlesPerBatch = type.meshNumPerBatch;
            var batchNum = ceil(partNum / particlesPerBatch);
            partSystem.drawCalls += batchNum;
            shader_set_uniform_f(spUniGrid[# sPartUni.partNum, uniInd], batchNum * particlesPerBatch);
            for (var k = 0; k < batchNum; k ++)
            {
                shader_set_uniform_f(spUniGrid[# sPartUni.batchInd, uniInd], k * particlesPerBatch);
                vertex_submit(vbuff, pr_trianglelist, tex);
            }
            exit;
        }

        //Draw billboard particles
        var batchSizeArray = partSystem.batchSizeArray;
        var vertexBatchArray = partSystem.vertexBatchArray;
        var indexNum = array_length(batchSizeArray);
        var index = 0;
        while (index < indexNum-1 && partNum > batchSizeArray[index])
        {
            index ++;
        }
        var vbuff = vertexBatchArray[index];
        var particlesPerBatch = batchSizeArray[index];
        var batchNum = ceil(partNum / particlesPerBatch);
        partSystem.drawCalls += batchNum;
        shader_set_uniform_f(spUniGrid[# sPartUni.partNum, uniInd], batchNum * particlesPerBatch);
        for (var k = 0; k < batchNum; k ++)
        {
            shader_set_uniform_f(spUniGrid[# sPartUni.batchInd, uniInd], k * particlesPerBatch);
            vertex_submit(vbuff, pr_trianglelist, tex);
        }
    }
}