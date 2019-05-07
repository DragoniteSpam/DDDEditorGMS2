event_inherited();

save_script=serialize_save_entity_mesh;
load_script=serialize_load_entity_mesh;

name="Mesh";
etype=ETypes.ENTITY_MESH;

ActiveMap.population[ETypes.ENTITY_MESH]++;

// THIS REALLY SHOULD BE SWITCHED TO SOME KIND OF GUID THING
// LATER. NOBODY WANTS NAME CONFLICTS EVERY TIME THEY RENAME
// A MESH. THANK.

mesh_id="";

// other properties - inherited

am_solid=true;
ActiveMap.population_solid++;

// editor properties

mesh_data=noone;

slot=MapCellContents.MESHMOB;
rotateable=true;
offsettable=true;
scalable=true;

batch=batch_mesh;
render=render_mesh;
selector=select_single;
on_select=safc_on_mesh;

