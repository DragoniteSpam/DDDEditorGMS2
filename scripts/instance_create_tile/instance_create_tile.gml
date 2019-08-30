/// @param tile x
/// @param tile y
/// @param [other]

with (instantiate(EntityTile)) {
    tile_x = argument[0];
    tile_y = argument[1];
    
    var other_data = (argument_count > 2) ? argument[2] : undefined;
    
    entity_init_collision_tile(id);
    
    return id;
}