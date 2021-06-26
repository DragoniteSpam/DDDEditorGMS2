function instance_create_terrain() {
    var at = new EntityMeshAutotile();
    at.name = "Terrain";
    at.cobject = c_object_create_cached(Stuff.graphics.c_shape_block, CollisionMasks.MAIN, CollisionMasks.MAIN);
    return at;
}