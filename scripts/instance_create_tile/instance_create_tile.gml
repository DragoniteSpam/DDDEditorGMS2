/// @param tile-x
/// @param tile-y
/// @param [other]
function instance_create_tile() {

    var tile = new EntityTile();
    tile.tile_x = argument[0];
    tile.tile_y = argument[1];

    var other_data = (argument_count > 2) ? argument[2] : undefined;

    entity_tile_update_vbuffer(tile);
    entity_init_collision_tile(tile);

    return tile;


}
