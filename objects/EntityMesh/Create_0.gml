event_inherited();

save_script = serialize_save_entity_mesh;
load_script = serialize_load_entity_mesh;

name = "Mesh";
etype = ETypes.ENTITY_MESH;

Stuff.active_map.population[ETypes.ENTITY_MESH]++;

// GUID
mesh = 0;

// other properties - inherited

am_solid = true;
Stuff.active_map.population_solid++;

// editor properties

slot = MapCellContents.MESHMOB;
rotateable = true;
offsettable = true;
scalable = true;

batch = batch_mesh;
render = render_mesh;
selector = select_single;
on_select = safc_on_mesh;