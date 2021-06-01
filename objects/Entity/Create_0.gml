name = "Entity";
etype = ETypes.ENTITY;
etype_flags = 0;
exist_in_map = true;

refid_set(id, refid_generate());

tmx_id = 0;

Stuff.map.active_map.contents.population[ETypes.ENTITY]++;

visible_routes = array_create(MAX_VISIBLE_MOVE_ROUTES);

// for fusing all static objects such as ground tiles and houses together,
// so the computer doesn't waste time drawing every single visible Entity
// individually
batch = null;

// when creating one giant collision shape
batch_collision = null;

// for things that don't fit into the above category, including but not limited
// to NPCs, things that animate, things that move and things that need special shaders
render = null;

// for what happens when you click on the entity
selector = null;

// files
save_script = serialize_save_entity;
load_script = serialize_load_entity;

// you can have scripts that do both, if you want to have a static thing that
// sparkles or something

// serialize
xx = 0;           // u32
yy = 0;           // u32
zz = 0;           // u32

off_xx = 0;       // f32
off_yy = 0;       // f32
off_zz = 0;       // f32

rot_xx = 0;       // u16
rot_yy = 0;       // u16
rot_zz = 0;       // u16

scale_xx = 1;     // f32
scale_yy = 1;     // f32
scale_zz = 1;     // f32

object_events = ds_list_create();         // i'm imposing a hard limit of 10 of these

switches = array_create(BASE_SELF_VARIABLES, 0);
variables = array_create(BASE_SELF_VARIABLES, 0);

// options
direction_fix = true;
always_update = false;
preserve_on_save = false;
reflect = false;
slope = ATMask.NONE;

generic_data = ds_list_create();

// autonomous movement - only useful for things not marked as "static"

autonomous_movement = AutonomousMovementTypes.FIXED;
autonomous_movement_speed = 3;                            // 0: 0.125, 1: 0.25, 2: 0.5, 3: 1, 4: 2, 5: 4
autonomous_movement_frequency = 2;                        // 0 through 4
autonomous_movement_route = NULL;

movement_routes = ds_list_create();             // list of DataMovementRoutes

enum AutonomousMovementTypes {
    FIXED,
    RANDOM,
    APPROACH,
    CUSTOM
}

// these are a formality
target_xx = xx;
target_yy = yy;
target_zz = zz;
previous_xx = xx;
previous_yy = yy;
previous_zz = zz;

/* s */ is_static = false;

// editor properties

// the game will know in advance whether something is to be batched or not.
// the editor may chance this on the fly. remember to override this in dynamic entities.
batchable = true;
batch_addr = undefined;                // pointer to a batch struct
modification = Modifications.CREATE;

translateable = true;
offsettable = false;
rotateable = false;
scalable = false;

slot = MapCellContents.TILE;
listed = false; // sigh

enum Modifications {
    NONE,
    CREATE,
    UPDATE,
    REMOVE
}

// whether you're allowed to stick multiple of these (same type of)
// objects at in the same cell
coexist = false;

// collision data
cobject = noone;

on_select = safc_on_entity;
on_deselect = safc_on_entity_deselect;
on_select_ui = safc_on_entity_ui;
get_bounding_box = entity_bounds_one;

SetCollisionTransform = function() {
    if (c_object_exists(cobject)) {
        c_world_add_object(cobject);
        c_object_set_userid(cobject, self.id);
        c_transform_position(xx * TILE_WIDTH, yy * TILE_HEIGHT, zz * TILE_DEPTH);
        c_object_apply_transform(cobject);
        c_transform_identity();
    }
};

SetStatic = function(state) {
    return false;
};