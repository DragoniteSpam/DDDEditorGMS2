/// @description  void sa_foreach_global(script, params array);
/// @param script
/// @param  params array
// processes each selected thing, regardless of whether or not they're
// selected

for (var i=0; i<ds_list_size(ActiveMap.all_entities); i++){
    var thing=ActiveMap.all_entities[| i];
    script_execute(argument0, thing, argument1);
}
