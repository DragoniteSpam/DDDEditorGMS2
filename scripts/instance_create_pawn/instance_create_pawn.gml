/// @description EntityPawn instance_create_pawn([other parameters that should be dealt with later]);
/// @param [other parameters that should be dealt with later]

with (instantiate(EntityPawn)) {
    switch (argument_count) {
        case 1:
            break;
    }
    
    entity_init_collision_pawn(id);
    
    return id;
}
