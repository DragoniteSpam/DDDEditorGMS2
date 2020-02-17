event_inherited();

file_location = DataFileLocations.ASSET;
type = MeshTypes.RAW;

animations = ds_map_create();           // this should map an animation name onto an index

/* s */ buffers = ds_list_create();
vbuffers = ds_list_create();
wbuffers = ds_list_create();
// there will only be one collision shape, defined as the first mesh
// you import; this is a good reason to make all meshes in a series
// the same shape, or almost the same shape
cshape = noone;

proto_guids = ds_map_create();

/* s */ xmin = 0;
/* s */ ymin = 0;
/* s */ zmin = 0;
/* s */ xmax = 1;
/* s */ ymax = 1;
/* s */ zmax = 1;

/* s */ collision_flags = ds_grid_create(xmax - xmin, ymax - ymin);
collision_flags[# 0, 0] = array_create(zmax - zmin);

/* s */ flags = 0;          // overrides Data.flags

ds_list_add(Stuff.all_meshes, id);

preview_index = 0;

enum MeshTypes {
    RAW,
    SMF
}