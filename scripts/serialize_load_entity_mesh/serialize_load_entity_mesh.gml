/// @param buffer
/// @param Entity
/// @param version

var buffer = argument0;
var entity = argument1;
var version = argument2;

serialize_load_entity(buffer, entity, version);

entity.mesh = buffer_read(buffer, buffer_datatype);

var bools = buffer_read(buffer, buffer_u32);

entity.animated = unpack(bools, 0);
entity.animation_index = buffer_read(buffer, buffer_u32);
entity.animation_type = buffer_read(buffer, buffer_u8);

var mesh_data = guid_get(entity.mesh);

if (mesh_data) {
    entity_init_collision_mesh(entity);
    
    switch (mesh_data.type) {
        case MeshTypes.RAW:
            break;
            entity.batchable = true;
        case MeshTypes.SMF:
            entity.batchable = false;
            break;
    }
} else {
    // @togo gml try catch - i think you'll want to do something of the "mesh not found" variety
}