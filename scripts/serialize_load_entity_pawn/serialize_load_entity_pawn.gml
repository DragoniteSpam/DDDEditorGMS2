/// @param buffer
/// @param EntityPawn
/// @param version

var buffer = argument0;
var pawn = argument1;
var version = argument2;

serialize_load_entity(buffer, pawn, version);

pawn.map_direction = buffer_read(buffer, buffer_u8);
if (version >= DataVersions.PAWN_HELPFUL_DATA) {
    pawn.overworld_sprite = buffer_read(buffer, buffer_datatype);
} else {
    if (ds_list_empty(Stuff.all_graphic_overworlds)) {
        pawn.overworld_sprite = 0;
    } else {
        pawn.overworld_sprite = Stuff.all_graphic_overworlds[| 0].GUID;
    }
}

entity_init_collision_pawn(pawn);