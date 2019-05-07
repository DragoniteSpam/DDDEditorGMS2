/// @description  void data_rename_map(ActiveMap, new_name);
/// @param ActiveMap
/// @param  new_name

if (ds_map_exists(Stuff.all_maps, argument1)){
    dialog_create_notice(noone, "A map with that internal name is already recognized by this project. Please try a different name, or dereference the old one (File > Settings - Data) if you don't want it to be part of the project any longer.");
} else {
    var old_name=argument0.internal_name;
    if (ds_map_exists(Stuff.all_maps, old_name)){
        ds_map_delete(Stuff.all_maps, old_name);
    }
    
    argument0.internal_name=argument1;
    ds_map_add(Stuff.all_maps, argument1, true);
}
