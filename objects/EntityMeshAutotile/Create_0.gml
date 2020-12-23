event_inherited();

save_script = serialize_save_entity_mesh_autotile;
load_script = serialize_load_entity_mesh_autotile;

name = "Terrain";
etype = ETypes.ENTITY_MESH_AUTO;
etype_flags = ETypeFlags.ENTITY_MESH_AUTO;

terrain_id = 0;                                             // mask
terrain_type = MeshAutotileLayers.TOP;                      // layer
autotile_id = Settings.selection.mesh_autotile_type;        // autotile asset

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