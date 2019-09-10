/// @param autotile-index
/// @param [other]

with (instance_create_depth(0, 0, 0, EntityAutoTile)) {
    autotile_id = argument[0];
    
    var other_data = (argument_count > 1) ? argument[1] : undefined;
    
    entity_init_collision_tile(id);
    
    return id;
}