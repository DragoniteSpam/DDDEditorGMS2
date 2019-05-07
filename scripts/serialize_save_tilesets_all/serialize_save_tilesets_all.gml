/// @description  void serialize_save_tilesets_meta(buffer);
/// @param buffer

buffer_write(argument0, buffer_datatype, SerializeThings.TILESET_ALL);

buffer_write(argument0, buffer_u8, Stuff.setting_embed_tilesets);

var n_tilesets=ds_list_size(Stuff.all_tilesets);
buffer_write(argument0, buffer_u16, n_tilesets);

for (var i=0; i<n_tilesets; i++){
    var ts=Stuff.all_tilesets[| i];
    
    buffer_write(argument0, buffer_string, ts.picture_name);
    
    // stash the sprite in the buffer (via surface)
    var surface=sprite_to_surface(ts.picture, 0);
    var sw=surface_get_width(surface);
    var sh=surface_get_height(surface);
    var sbuffer=buffer_create(sw*sh*4, buffer_fixed, 1);
    surface_save(surface, "surface.png");
    buffer_get_surface(sbuffer, surface, 0, 0, 0);
    
    buffer_save(sbuffer, "binarypng.bin")
    
    buffer_write(argument0, buffer_u16, sw);
    buffer_write(argument0, buffer_u16, sh);
    var where=buffer_tell(argument0);
    buffer_copy(sbuffer, 0, buffer_get_size(sbuffer), argument0, buffer_tell(argument0));
    
    buffer_seek(argument0, buffer_seek_start, where);
    
    //buffer_seek(sbuffer, buffer_seek_start, 0);
    var f=file_text_open_write("pnglog-in.txt");
    /*repeat(sw*sh){
        var aaa=buffer_read(argument0, buffer_u8);
        var bbb=buffer_read(argument0, buffer_u8);
        var ggg=buffer_read(argument0, buffer_u8);
        var rrr=buffer_read(argument0, buffer_u8);
        //file_text_write_string(f, "r: "+string(rrr)+"      g: "+string(ggg)+"      b: "+string(bbb)+"      a: "+string(aaa))
        debug("r: "+string(rrr)+"      g: "+string(ggg)+"      b: "+string(bbb)+"      a: "+string(aaa))
        //file_text_writeln(f);
    }*/
    
    file_text_close(f);
    
    surface_free(surface);
    buffer_delete(sbuffer);
    
    // all of the other things
    
    // THESE ARE INDICES IN Stuff.available_autotiles!
    // THOSE NEED TO BE SAVED AS WELL! Do it later though.
    // with that in mind, saving these are trivially easy.
    var n_autotiles=array_length_1d(ts.autotiles);
    buffer_write(argument0, buffer_u8, n_autotiles);
    
    for (var j=0; j<n_autotiles; j++){
        // s16 because no tile is "noone"
        buffer_write(argument0, buffer_s16, ts.autotiles[j]);
        
        buffer_write(argument0, buffer_u8, ts.at_passage[j]);
        buffer_write(argument0, buffer_u8, ts.at_priority[j]);
        buffer_write(argument0, buffer_u8, ts.at_flags[j]);
        buffer_write(argument0, buffer_u8, ts.at_tags[j]);
    }
    
    // all of these grids will be the same dimensions so the
    // data can be saved in one loop
    
    var t_grid_width=ds_grid_width(ts.passage);
    var t_grid_height=ds_grid_height(ts.passage);
    
    buffer_write(argument0, buffer_u16, t_grid_width);
    buffer_write(argument0, buffer_u16, t_grid_height);
    
    for (var j=0; j<t_grid_width; j++){
        for (var k=0; k<t_grid_height; k++){
            buffer_write(argument0, buffer_u8, ts.passage[# j, k]);
            buffer_write(argument0, buffer_u8, ts.priority[# j, k]);
            buffer_write(argument0, buffer_u8, ts.flags[# j, k]);
            buffer_write(argument0, buffer_u8, ts.tags[# j, k]);
        }
    }
}
