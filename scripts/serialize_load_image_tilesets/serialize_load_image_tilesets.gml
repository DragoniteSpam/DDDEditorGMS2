/// @param buffer
/// @param version

var buffer = argument0;
var version = argument1;

if (version >= DataVersions.DATA_CHUNK_ADDRESSES) {
    var addr_next = buffer_read(buffer, buffer_u64);
}

ds_list_clear_instances(Stuff.all_graphic_tilesets);

var n_tilesets = buffer_read(buffer, buffer_u16);

for (var i = 0; i < n_tilesets; i++) {
    // don't use load_generic here because flags is now an array and that
    // will break things
    var name = buffer_read(buffer, buffer_string);
    var internal_name = buffer_read(buffer, buffer_string);
    var summary = buffer_read(buffer, buffer_string);
    var guid = buffer_read(buffer, buffer_u32);
    
    var ts_name = buffer_read(buffer, buffer_string);
    
    var sprite = buffer_read_sprite(buffer);
    
    // all of the other things
    var n_autotiles = buffer_read(buffer, buffer_u8);
    var at_array = array_create(n_autotiles);
    var at_passage = array_create(n_autotiles);
    var at_priority = array_create(n_autotiles);
    var at_flags = array_create(n_autotiles);
    var at_tags = array_create(n_autotiles);
    
    for (var j = 0; j < n_autotiles; j++) {
        // s16 because no tile is "noone"
        at_array[j] = buffer_read(buffer, buffer_s16);
        at_passage[j] = buffer_read(buffer, buffer_u8);
        at_priority[j] = buffer_read(buffer, buffer_u8);
        at_flags[j] = buffer_read(buffer, buffer_u8);
        at_tags[j] = buffer_read(buffer, buffer_u8);
    }
    
    var ts = tileset_create(ts_name, at_array, sprite);
    
    ts.name = name;
    ts.internal_name = internal_name;
    ts.summary = summary;
    guid_set(ts, guid, true);
    
    // i really hope the garbage collector is doing its job with the old arrays
    
    ts.at_passage = at_passage;
    ts.at_priority = at_priority;
    ts.at_flags = at_flags;
    ts.at_tags = at_tags;
    
    var t_grid_width = buffer_read(buffer, buffer_u16);
    var t_grid_height = buffer_read(buffer, buffer_u16);
    
    // the way i did this is a little weird and i don't know why - the grids
    // (and autotile arrays, for that matter) already exist so there's no point
    // in recreating them, so just populate their values instead
    
    for (var j = 0; j < t_grid_width; j++) {
        for (var k = 0; k < t_grid_height; k++) {
            ts.passage[# j, k] = buffer_read(buffer, buffer_u8);
            ts.priority[# j, k] = buffer_read(buffer, buffer_u8);
            ts.flags[# j, k] = buffer_read(buffer, buffer_u8);
            ts.tags[# j, k] = buffer_read(buffer, buffer_u8);
        }
    }
    
    ds_list_add(Stuff.all_graphic_tilesets, ts);
    
    ds_list_clear(ts.terrain_tag_names);
    var n = buffer_read(buffer, buffer_u8);
    repeat (n) {
        ds_list_add(ts.terrain_tag_names, buffer_read(buffer, buffer_string));
    }
}