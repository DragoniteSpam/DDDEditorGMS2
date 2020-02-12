/// @param buffer
/// @param Entity
/// @param version

var buffer = argument0;
var entity = argument1;
var version = argument2;

serialize_load_entity_mesh(buffer, entity, version);

if (version >= DataVersions.MESH_AUTOTILE_FINISHED) {
    entity.terrain_id = buffer_read(buffer, buffer_u8);
    entity.terrain_type = buffer_read(buffer, buffer_u8);
}

// i screwed this one up good
if (version >= DataVersions.AUTOTILE_DESIGNATION_SLOPE_WHOOPS) {
    if (version >= DataVersions.AUTOTILE_DESIGNATION_SLOPE_WHOOPS_x2) {
    } else {
        buffer_read(buffer, buffer_u32);
    }
}