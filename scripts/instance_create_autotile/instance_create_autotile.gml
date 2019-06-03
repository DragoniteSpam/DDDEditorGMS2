/// @description EntityAutoTile instance_create_autotile(autotile index, [other parameters that should be dealt with later]);
/// @param autotile index
/// @param [other parameters that should be dealt with later]

with (instantiate(EntityAutoTile)) {
    switch (argument_count) {
        case 1:
            autotile_id=argument[0];
            break;
    }
    
    entity_init_collision_tile(id);
    
    return id;
}
