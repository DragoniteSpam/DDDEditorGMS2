/// @param tile-x
/// @param tile-y
/// @param [other]
function instance_create_tile() {

    with (instance_create_depth(0, 0, 0, EntityTile)) {
        tile_x = argument[0];
        tile_y = argument[1];
    
        var other_data = (argument_count > 2) ? argument[2] : undefined;
    
        entity_tile_update_vbuffer(id);
        entity_init_collision_tile(id);
    
        return id;
    }


}
