/// @param autotile-index
/// @param [other]

with (instantiate(EntityAutoTile)) {
    switch (argument_count) {
        case 1:
            autotile_id = argument[0];
            break;
    }
    
    entity_init_collision_tile(id);
    
    return id;
}