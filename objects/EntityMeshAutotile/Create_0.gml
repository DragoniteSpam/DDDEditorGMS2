event_inherited();

save_script = serialize_save_entity_mesh_autotile;
load_script = serialize_load_entity_mesh_autotile;

name = "Terrain";
etype = ETypes.ENTITY_MESH_AUTO;
etype_flags = ETypeFlags.ENTITY_MESH_AUTO;

terrain_id = 0;
terrain_type = ATTerrainTypes.TOP;

// editor properties
slot = MapCellContents.MESH;
rotateable = false;
offsettable = false;
scalable = false;

batch = batch_mesh_autotile;
render = render_mesh_autotile;
selector = select_single;
on_select_ui = safc_on_mesh_ui;

enum ATTerrainTypes {
    TOP,
    VERTICAL,
    BASE,
    SLOPE,
}