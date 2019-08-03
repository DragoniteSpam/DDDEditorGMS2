name = "Layer 0";
is_actor = false;

// list of Keyframes - the game would prefer this to be a priority queue
// but we need to randomly access them so they're not
keyframes = ds_list_create();

// base values

xx = 0;
yy = 0;
zz = 0;
xrot = 0;
yrot = 0;
zrot = 0;
xscale = 1;
yscale = 1;
zscale = 1;

color = c_white;
alpha = 1;

graphic_type = GraphicTypes.NO_CHANGE;
graphic = noone;
graphic_speed = 1;

enum GraphicTypes {
    NONE,
    NO_CHANGE,
    SPRITE,
    MESH
}