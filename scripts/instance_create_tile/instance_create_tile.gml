/// @param tile x
/// @param tile y
/// @param [other]

with (instantiate(EntityTile)) {
    switch (argument_count) {
        case 2:
            tile_y = argument[1];
            tile_x = argument[0];
            break;
    }
    
    entity_init_collision_tile(id);
    
    return id;
}