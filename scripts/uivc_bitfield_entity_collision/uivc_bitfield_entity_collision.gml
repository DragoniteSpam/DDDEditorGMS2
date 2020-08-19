/// @param UIBitfield
function uivc_bitfield_entity_collision(argument0) {

    var bitfield = argument0;

    var entity = bitfield.root.root.entity;
    entity.collision_flags = entity.collision_flags ^ (1 << bitfield.value);


}
