/// @param [other]

with (instantiate(EntityPawn)) {
    // this feels very dumb
    var other_data = (argument_count > 0) ? argument[0] : undefined;
    
    entity_init_collision_pawn(id);
    
    return id;
}