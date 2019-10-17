event_inherited();

save_script = serialize_save_entity_mesh;
load_script = serialize_load_entity_mesh;

name = "Mesh";
etype = ETypes.ENTITY_MESH;

Stuff.active_map.contents.population[ETypes.ENTITY_MESH]++;

// GUID
mesh = 0;
animated = false;
animation_index = 0;
animation_type = SMF_loop_linear;

// other properties - inherited

am_solid = true;
Stuff.active_map.contents.population_solid++;

// editor properties

slot = MapCellContents.MESHPAWN;
rotateable = true;
offsettable = true;
scalable = true;

batch = batch_mesh;
batch_collision = batch_collision_mesh;
render = render_mesh;
selector = select_single;
on_select = safc_on_mesh;