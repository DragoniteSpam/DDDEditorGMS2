event_inherited();

file_location = DataFileLocations.ASSET;
type = MeshTypes.RAW;

animations = ds_map_create();           // this should map an animation name onto an index

/* s */ buffer = noone;
vbuffer = noone;
wbuffer = noone;
cshape = noone;

/* s */ xmin = 0;
/* s */ ymin = 0;
/* s */ zmin = 0;
/* s */ xmax = 1;
/* s */ ymax = 1;
/* s */ zmax = 1;

collision_flags = ds_grid_create(xmax - xmin, ymax - ymin);
collision_flags[# 0, 0] = array_create(zmax - zmin);

/* s */ default_solid = true;
/* s */ flags = 0;          // overrides Data.flags

ds_list_add(Stuff.all_meshes, id);

enum MeshTypes {
    RAW,
    SMF
}