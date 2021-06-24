/// @param buffer
/// @param EntityPawn
function serialize_save_entity_pawn(argument0, argument1) {

    var buffer = argument0;
    var pawn = argument1;

    serialize_save_entity(buffer, pawn);

    buffer_write(buffer, buffer_u8, pawn.map_direction);
    buffer_write(buffer, buffer_datatype, pawn.overworld_sprite);


}
