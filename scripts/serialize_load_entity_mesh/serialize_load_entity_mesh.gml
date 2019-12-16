/// @param buffer
/// @param Entity
/// @param version

var buffer = argument0;
var entity = argument1;
var version = argument2;

serialize_load_entity(buffer, entity, version);

entity.mesh = buffer_read(buffer, buffer_datatype);
if (entity.mesh == 0) {
    // @togo gml try catch
    not_yet_implemented_polite();
    return false;
}

var bools = buffer_read(buffer, buffer_u32);

entity.animated = unpack(bools, 0);
entity.animation_index = buffer_read(buffer, buffer_u32);
entity.animation_type = buffer_read(buffer, buffer_u8);

entity_init_collision_mesh(entity);