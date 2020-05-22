event_inherited();

save_script = serialize_save_entity_mesh;
load_script = serialize_load_entity_mesh;

name = "Mesh";
etype = ETypes.ENTITY_MESH;
etype_flags = ETypeFlags.ENTITY_MESH;

Stuff.map.active_map.contents.population[ETypes.ENTITY_MESH]++;

static = true;

mesh = NULL;
mesh_submesh = 0;                   // proto-GUID
animated = false;
animation_index = 0;
animation_type = SMF_loop_linear;
animation_speed = 0;
animation_end_action = AnimationEndActions.LOOP;

// editor properties

slot = MapCellContents.MESH;
rotateable = true;
offsettable = true;
scalable = true;

batch = batch_mesh;
batch_collision = batch_collision_mesh;
render = render_mesh;
selector = select_single;
on_select_ui = safc_on_mesh_ui;
get_bounding_box = entity_bounds_mesh;