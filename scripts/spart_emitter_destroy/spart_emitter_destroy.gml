/// @description spart_emitter_destroy(ind)
/// @param ind
function spart_emitter_destroy(argument0) {
    /*
        Destroys the given emitter and all its children

        Script created by TheSnidr
        www.thesnidr.com
    */
    var partEmitter = argument0;
    var partSystem = partEmitter[| sPartEmt.PartSystem];

    for (var i = ds_list_size(partSystem[| sPartSys.EmitterList]) - 1; i >= 0; i --)
    {
        var testEmitter = ds_list_find_value(partSystem[| sPartSys.EmitterList], i);
        if (testEmitter[| sPartEmt.Parent] == partEmitter || testEmitter == partEmitter)
        {
            ds_list_destroy(testEmitter);
            ds_list_delete(partSystem[| sPartSys.EmitterList], i);
            var j = ds_list_find_index(partSystem[| sPartSys.ActiveEmitterList], testEmitter) - 1;
            if (j >= 0)
            {
                ds_list_delete(partSystem[| sPartSys.ActiveEmitterList], j);
                ds_list_delete(partSystem[| sPartSys.ActiveEmitterList], j);
            }
            var j = ds_list_find_index(partSystem[| sPartSys.StepEmitterList], testEmitter) - 1;
            if (j >= 0)
            {
                ds_list_delete(partSystem[| sPartSys.StepEmitterList], j);
                ds_list_delete(partSystem[| sPartSys.StepEmitterList], j);
            }
            var j = ds_list_find_index(partSystem[| sPartSys.DeathEmitterList], testEmitter) - 1;
            if (j >= 0)
            {
                ds_list_delete(partSystem[| sPartSys.DeathEmitterList], j);
                ds_list_delete(partSystem[| sPartSys.DeathEmitterList], j);
            }
        }
    }


}
