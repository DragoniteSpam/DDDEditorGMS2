event_inherited();

file_location = DataFileLocations.ASSET;

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

/* s */ passage = TILE_PASSABLE;
/* s */ flags = 0;          // overrides Data.flags
/* s */ tags = 0;

ds_list_add(Stuff.all_meshes, id);