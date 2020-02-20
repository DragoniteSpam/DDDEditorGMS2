event_inherited();

file_location = DataFileLocations.ASSET;
type = MeshTypes.RAW;

animations = ds_map_create();           // this should map an animation name onto an index
marker = 0;                             // this is really a second Flags list, but those are being used as asset flags and i want to keep them separate

submeshes = ds_list_create();
// there will only be one collision shape, defined as the first mesh
// you import; this is a good reason to make all meshes in a series
// the same shape, or almost the same shape
cshape = noone;

proto_guids = ds_map_create();
first_proto_guid = 0;

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

enum MeshMarkers {
    PARTICLE            = 0x0001,
}