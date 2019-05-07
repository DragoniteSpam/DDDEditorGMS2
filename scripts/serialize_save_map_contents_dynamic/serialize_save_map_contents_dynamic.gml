/// @description  void serialize_save_map_contents_dynamic(buffer, list_dynamic);
/// @param buffer
/// @param  list_dynamic
// this was originally supposed to be only entities not marked as "static," but
// it became obvious that wasn't going to work pretty quickly, so now they're all
// entities that haven't been baked together. the save_map_contents_static has
// been renamed to save_map_contents_batch to avoid confusion.

buffer_write(argument0, buffer_datatype, SerializeThings.MAP_DYNAMIC);

var n_things=ds_list_size(ActiveMap.all_entities);
buffer_write(argument0, buffer_u32, n_things);

for (var i=0; i<n_things; i++){
    var thing=ActiveMap.all_entities[| i];
    buffer_write(argument0, buffer_u16, thing.etype);
    script_execute(thing.save_script, argument0, thing);
}
