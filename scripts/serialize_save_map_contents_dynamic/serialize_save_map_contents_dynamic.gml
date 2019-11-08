/// @param buffer

// this was originally supposed to be only entities not marked as "static," but
// it became obvious that wasn't going to work pretty quickly, so now they're all
// entities that haven't been baked together. the save_map_contents_static has
// been renamed to save_map_contents_batch to avoid confusion.

var buffer = argument0;

buffer_write(buffer, buffer_datatype, SerializeThings.MAP_DYNAMIC);

var n_things = ds_list_size(Stuff.map.active_map.contents.all_entities);
buffer_write(buffer, buffer_u32, n_things);

for (var i = 0; i < n_things; i++) {
    var thing = Stuff.map.active_map.contents.all_entities[| i];
    buffer_write(buffer, buffer_u16, thing.etype);
	buffer_write(buffer, buffer_u32, thing.tmx_id);
    script_execute(thing.save_script, buffer, thing);
}