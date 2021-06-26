function instance_create_tile_animated() {
    var tile = new EntityTileAnimated();
    tile.cobject = c_object_create_cached(Stuff.graphics.c_shape_tile, CollisionMasks.MAIN, CollisionMasks.MAIN);
    return tile;


}
