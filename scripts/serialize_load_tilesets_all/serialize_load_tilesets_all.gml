/// void serialize_load_tilesets_all(buffer, version);

var version=argument1;

var embedded_tilesets=buffer_read(argument0, buffer_u8);

ds_list_clear_instances(Stuff.all_tilesets);

var n_tilesets=buffer_read(argument0, buffer_u16);
for (var i=0; i<n_tilesets; i++){
    var ts_name=buffer_read(argument0, buffer_string);
    
    // retrieve the surface from the buffer
    var sw=buffer_read(argument0, buffer_u16);
    var sh=buffer_read(argument0, buffer_u16);
    var sbuffer=buffer_create(sw*sh*4, buffer_grow, 1);
    buffer_copy(argument0, buffer_tell(argument0), sw*sh*4, sbuffer, 0);
    
    buffer_set_surface is either broken or not broken but i dont have time
    to figure out how to make it not broken now, so do that next
    
    // all of the other things
    var n_autotiles=buffer_read(argument0, buffer_u8);
    var at_array=array_create(n_autotiles);
    var at_passage=array_create(n_autotiles);
    var at_priority=array_create(n_autotiles);
    var at_flags=array_create(n_autotiles);
    var at_tags=array_create(n_autotiles);
    
    for (var j=0; j<n_autotiles; j++){
        // s16 because no tile is "noone"
        at_array[j]=buffer_read(argument0, buffer_s16);
        at_passage[j]=buffer_read(argument0, buffer_u8);
        at_priority[j]=buffer_read(argument0, buffer_u8);
        at_flags[j]=buffer_read(argument0, buffer_u8);
        at_tags[j]=buffer_read(argument0, buffer_u8);
    }
    
    var ts=tileset_create(ts_name, at_array, sprite);
    
    // i really hope the garbage collector is doing its job with the old arrays
    
    ts.at_passage=at_passage;
    ts.at_priority=at_priority;
    ts.at_flags=at_flags;
    ts.at_tags=at_tags;
    
    var t_grid_width=buffer_read(argument0, buffer_u16);
    var t_grid_height=buffer_read(argument0, buffer_u16);
    
    // the way i did this is a little weird and i don't know why - the grids
    // (and autotile arrays, for that matter) already exist so there's no point
    // in recreating them, so just populate their values instead
    
    for (var j=0; j<t_grid_width; j++){
        for (var k=0; k<t_grid_height; k++){
            ts.passage[# j, k]=buffer_read(argument0, buffer_u8);
            ts.priority[# j, k]=buffer_read(argument0, buffer_u8);
            ts.flags[# j, k]=buffer_read(argument0, buffer_u8);
            ts.tags[# j, k]=buffer_read(argument0, buffer_u8);
        }
    }
    
    ds_list_add(Stuff.all_tilesets, ts);
}

//uivc_select_autotile_refresh(/*Camera.selection_fill_autotile*/);
