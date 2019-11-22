event_inherited();

save_script = serialize_save_entity_mesh_terrain;
load_script = serialize_load_entity_mesh_terrain;

name = "Terrain";
etype = ETypes.ENTITY_MESH;

terrain_id = 0;

// other properties - inherited

am_solid = true;
Stuff.map.active_map.contents.population_solid++;

// editor properties

// make this a GUID the same way normal meshes do
not_yet_implemented_polite();
mesh_id = 0;
// find and deal with variables named "mesh_data_raw" because that was here
// and i dont know what it was for

slot = MapCellContents.MESHPAWN;
rotateable = true;
offsettable = true;
scalable = true;

batch = batch_mesh_terrain;
render = render_mesh_terrain;
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