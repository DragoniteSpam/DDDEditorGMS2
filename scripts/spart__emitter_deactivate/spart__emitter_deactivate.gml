/// @description spart__emitter_deactivate(partEmitter)
/// @param partEmitter
function spart__emitter_deactivate(argument0) {
    /*
        Removes the emitter from the active emitter lists
    
        Script created by TheSnidr
        www.TheSnidr.com
    */
    var partEmitter = argument0;
    var partSystem = partEmitter[| sPartEmt.PartSystem];
    var stepList = partSystem[| sPartSys.StepEmitterList];
    var deathList = partSystem[| sPartSys.DeathEmitterList];
    var emitterList = partSystem[| sPartSys.ActiveEmitterList];

    //Remove the emitter from the active emitters list
    var i = ds_list_find_index(emitterList, partEmitter);
    if i >= 0
    {
        ds_list_delete(emitterList, i-1);
        ds_list_delete(emitterList, i-1);
    }

    //Remove the emitter from the step emitters list
    var i = ds_list_find_index(stepList, partEmitter);
    if i >= 0
    {
        ds_list_delete(stepList, i-1);
        ds_list_delete(stepList, i-1);
    }

    //Remove the emitter from the death emitters list
    var i = ds_list_find_index(deathList, partEmitter);
    if i >= 0
    {
        ds_list_delete(deathList, i-1);
        ds_list_delete(deathList, i-1);
    }


}
