/// @param buffer
/// @param Entity
/// @param version

var buffer = argument0;
var entity = argument1;
var version = argument2;

serialize_load_entity(buffer, entity, version);
entity.mesh = buffer_read(buffer, buffer_get_datatype(version));
entity.mesh_submesh = buffer_read(buffer, buffer_get_datatype(version));

var bools = buffer_read(buffer, buffer_u32);

entity.animated = unpack(bools, 0);
entity.animation_index = buffer_read(buffer, buffer_u32);
entity.animation_type = buffer_read(buffer, buffer_u8);

if (version >= DataVersions.MESH_ANIMATION) {
    entity.animation_speed = buffer_read(buffer, buffer_f32);
    entity.animation_endaction = buffer_read(buffer, buffer_u8);
}

var mesh_data = guid_get(entity.mesh);

if (mesh_data) {
    entity_init_collision_mesh(entity);
    
    switch (mesh_data.type) {
        case MeshTypes.RAW:
            entity.batchable = true;
            break;
        case MeshTypes.SMF:
            entity.batchable = false;
            break;
    }
}