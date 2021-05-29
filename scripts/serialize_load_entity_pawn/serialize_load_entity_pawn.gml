/// @param buffer
/// @param EntityPawn
/// @param version
function serialize_load_entity_pawn(argument0, argument1, argument2) {

    var buffer = argument0;
    var pawn = argument1;
    var version = argument2;

    serialize_load_entity(buffer, pawn, version);

    pawn.map_direction = buffer_read(buffer, buffer_u8);
    pawn.overworld_sprite = buffer_read(buffer, buffer_datatype);

    entity_init_collision_pawn(pawn);


}
