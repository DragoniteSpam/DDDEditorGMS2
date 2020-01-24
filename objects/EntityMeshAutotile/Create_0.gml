event_inherited();

save_script = serialize_save_entity_mesh_autotile;
load_script = serialize_load_entity_mesh_autotile;

name = "Terrain";
etype = ETypes.ENTITY_MESH_AUTO;

terrain_id = 0;
terrain_type = ATTerrainTypes.BASE;

// editor properties
slot = MapCellContents.MESHPAWN;
rotateable = false;
offsettable = false;
scalable = false;

batch = batch_mesh_autotile;
render = render_mesh_autotile;
selector = select_single;
on_select = safc_on_mesh;

enum ATMask {
    NORTHWEST   = 0x0001,
    NORTH       = 0x0002,
    NORTHEAST   = 0x0004,
    WEST        = 0x0008,
    EAST        = 0x0010,
    SOUTHWEST   = 0x0020,
    SOUTH       = 0x0040,
    SOUTHEAST   = 0x0080,
}

enum ATTerrainTypes {
    BASE,
    VERTICAL,
}