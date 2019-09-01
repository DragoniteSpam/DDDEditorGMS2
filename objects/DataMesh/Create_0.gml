event_inherited();

deleteable = false;

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

// we want to be in the list automatically
var ui_list = Camera.ui.element_mesh_list;
create_list_entries(ui_list, id);
ui_list.text = "Available meshes: " + string(ds_list_size(ui_list.entries));

ds_list_add(Stuff.all_meshes, id);