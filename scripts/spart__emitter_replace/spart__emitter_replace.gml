/// @description spart__emitter_replace(partEmitter, oldEmitter)
/// @param partEmitter
/// @param oldEmitter
function spart__emitter_replace(argument0, argument1) {
    /*
        Replaces a particle emitter in the active emitter lists
    
        Script created by TheSnidr
        www.TheSnidr.com
    */
    var partEmitter = argument0;
    var oldEmitter = argument1;
    var partSystem = partEmitter[| sPartEmt.PartSystem];
    var stepList = partSystem[| sPartSys.StepEmitterList];
    var deathList = partSystem[| sPartSys.DeathEmitterList];
    var emitterList = partSystem[| sPartSys.ActiveEmitterList];

    //Make sure the emitter is on the active emitters list
    var i = ds_list_find_index(emitterList, oldEmitter);
    if i >= 0
    {
        emitterList[| i] = partEmitter;
    }

    //Make sure the emitter is on the step emitters list
    var i = ds_list_find_index(stepList, oldEmitter);
    if i >= 0
    {
        stepList[| i] = partEmitter;
    }

    //Make sure the emitter is on the death emitters list
    var i = ds_list_find_index(deathList, oldEmitter);
    if i >= 0
    {
        deathList[| i] = partEmitter;
    }


}
