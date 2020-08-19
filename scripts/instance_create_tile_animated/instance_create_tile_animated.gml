function instance_create_tile_animated() {
    with (instance_create_depth(0, 0, 0, EntityTileAnimated)) {
        entity_init_collision_tile(id);
        return id;
    }


}
