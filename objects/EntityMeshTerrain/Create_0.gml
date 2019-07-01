event_inherited();

save_script = serialize_save_entity_mesh_terrain;
load_script = serialize_load_entity_mesh_terrain;

name = "Terrain";
etype = ETypes.ENTITY_MESH;

terrain_id = 

// other properties - inherited

am_solid = true;
ActiveMap.population_solid++;

// editor properties

mesh_data = noone;

slot = MapCellContents.MESHMOB;
rotateable = true;
offsettable = true;
scalable = true;

batch = batch_mesh;
render = render_mesh;
selector = select_single;
on_select = safc_on_mesh;

enum ATMask {
    NORTH       = 1 << 0,
    WEST        = 1 << 1,
    EAST        = 1 << 2,
    SOUTH       = 1 << 3,
}