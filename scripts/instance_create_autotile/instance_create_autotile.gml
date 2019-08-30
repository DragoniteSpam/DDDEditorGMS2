/// @param autotile-index
/// @param [other]

with (instantiate(EntityAutoTile)) {
    autotile_id = argument[0];
    
    var other_data = (argument_count > 1) ? argument[1] : undefined;
    
    entity_init_collision_tile(id);
    
    return id;
}