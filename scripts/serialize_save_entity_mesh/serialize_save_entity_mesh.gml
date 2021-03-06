function serialize_save_entity_mesh(buffer, entity) {
    serialize_save_entity(buffer, entity);
    buffer_write(buffer, buffer_datatype, entity.mesh);
    buffer_write(buffer, buffer_datatype, entity.mesh_submesh);
    var bools = pack(entity.animated);
    buffer_write(buffer, buffer_u32, bools);
    buffer_write(buffer, buffer_u32, entity.animation_index);
    buffer_write(buffer, buffer_u8, entity.animation_type);
    buffer_write(buffer, buffer_f32, entity.animation_speed);
    buffer_write(buffer, buffer_u8, entity.animation_end_action);
}