/// @description  EntityTile instance_create_tile(tile x, tile y, [other parameters that should be dealt with later]);
/// @param tile x
/// @param  tile y
/// @param  [other parameters that should be dealt with later]

with (instance_create(0, 0, EntityTile)){
    switch (argument_count){
        case 2:
            tile_y=argument[1];
            tile_x=argument[0];
            break;
    }
    
    entity_init_collision_tile(id);
    
    return id;
}
