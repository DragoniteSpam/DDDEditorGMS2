function instance_create_terrain() {
    with (instance_create_depth(0, 0, 0, EntityMeshAutotile)) {
        name = "Terrain";
        cobject = c_object_create_cached(Stuff.graphics.c_shape_block, CollisionMasks.MAIN, CollisionMasks.MAIN);
        return id;
    }
}