/// @param buffer
/// @param EntityPawn

var buffer = argument0;
var pawn = argument1;

serialize_save_entity(buffer, pawn);

buffer_write(buffer, buffer_u8, pawn.map_direction);
buffer_write(buffer, buffer_datatype, pawn.overworld_sprite);

if (!guid_get(pawn.overworld_sprite)) {
    global.error_map[? "ow-undefined"] = "One or more EntityPawns do not have an overworld sprite set";
}