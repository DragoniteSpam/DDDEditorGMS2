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
not_yet_implemented();
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
    NORTHWEST   = 1 << 0,
    NORTH       = 1 << 1,
    NORTHEAST   = 1 << 2,
    WEST        = 1 << 3,
    EAST        = 1 << 4,
    SOUTHWEST   = 1 << 5,
    SOUTH       = 1 << 6,
    SOUTHEAST   = 1 << 7,
}