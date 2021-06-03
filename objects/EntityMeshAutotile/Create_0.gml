event_inherited();

save_script = function(buffer, entity) {
    serialize_save_entity_mesh(buffer, entity);
    buffer_write(buffer, buffer_u8, entity.terrain_id);
    buffer_write(buffer, buffer_u8, entity.terrain_type);
    buffer_write(buffer, buffer_datatype, entity.autotile_id);
};
load_script = function(buffer, entity, version) {
    serialize_load_entity_mesh(buffer, entity, version);
    entity.terrain_id = buffer_read(buffer, buffer_u8);
    entity.terrain_type = buffer_read(buffer, buffer_u8);
    entity.autotile_id = buffer_read(buffer, buffer_datatype);
    entity.is_static = true;
};

name = "Terrain";
etype = ETypes.ENTITY_MESH_AUTO;
etype_flags = ETypeFlags.ENTITY_MESH_AUTO;

terrain_id = 0;                                             // mask
terrain_type = MeshAutotileLayers.TOP;                      // layer
autotile_id = Settings.selection.mesh_autotile_type;        // autotile asset

AutotileUniqueIdentifier = function() {
    return autotile_id + ":" + string(global.at_map[$ terrain_id]) + ":" + string(terrain_type);
};

// editor properties
slot = MapCellContents.MESH;
rotateable = false;
offsettable = false;
scalable = false;

batch = batch_mesh_autotile;
render = render_mesh_autotile;
selector = select_single;
on_select_ui = safc_on_mesh_ui;
get_bounding_box = entity_bounds_one;

enum MeshAutotileLayers {
    TOP, VERTICAL, BASE, SLOPE, __COUNT,
}

is_static = true;
SetStatic = function(state) {
    return false;
};

CreateJSONMeshAT = function() {
    var json = self.CreateJSONMesh();
    json.mesh_at = {
        id: self.terrain_id,
        type: self.terrain_type,
        autotile_id: self.autotile_id,
    };
    return json;
};

CreateJSON = function() {
    return self.CreateJSONMeshAT();
};