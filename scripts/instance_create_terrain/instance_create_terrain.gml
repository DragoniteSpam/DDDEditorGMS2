with (instance_create_depth(0, 0, 0, EntityMeshTerrain)) {
    name = "Terrain";
    
    // @todo slopes i guess?
    
    cobject = c_object_create(Stuff.c_shape_block, 1, 1);
    
    // mesh data is assigned in sa_process_selection
        
    return id;
}