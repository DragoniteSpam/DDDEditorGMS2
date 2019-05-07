/// @description  void sa_foreach_all(script, params array);
/// @param script
/// @param  params array
// processes each selected thing, but only if they're selected

for (var i=0; i<ds_list_size(ActiveMap.all_entities); i++){
    var thing=ActiveMap.all_entities[| i];
    if (selected(thing)){
        script_execute(argument0, thing, argument1);
    }
}
