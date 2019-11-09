with (instance_create_depth(0, 0, 0, EntityMeshTerrain)) {
    name = "Terrain";
    
    // @todo slopes i guess?
    cobject = c_object_create(Stuff.graphics.c_shape_block, CollisionMasks.MAIN, CollisionMasks.MAIN);
    
    return id;
}