function data_resize_map(map_container, xx, yy, zz) {
    var map_contents = map_container.contents;
    map_container.xx = xx;
    map_container.yy = yy;
    map_container.zz = zz;
    
    for (var i = 0; i < ds_list_size(map_contents.all_entities); i++) {
        var thing = map_contents.all_entities[| i];
        if (thing.xx >= xx || thing.yy >= yy || thing.zz >= zz) {
            safa_delete(thing);
        }
    }
    
    graphics_create_grids();
    
    array_resize_4d(map_contents.map_grid, xx, yy, zz, MapCellContents._COUNT);
    array_resize_3d(map_contents.map_grid_tags, xx, yy, zz);
    
    if (Stuff.game_starting_map == map_container.GUID) {
        Stuff.game_starting_x = min(Stuff.game_starting_x, xx - 1);
        Stuff.game_starting_y = min(Stuff.game_starting_y, yy - 1);
        Stuff.game_starting_z = min(Stuff.game_starting_z, zz - 1);
    }
    
    Stuff.map.ui.element_entity_pos_x.value_upper = xx - 1;
    Stuff.map.ui.element_entity_pos_y.value_upper = yy - 1;
    Stuff.map.ui.element_entity_pos_z.value_upper = zz - 1;
}