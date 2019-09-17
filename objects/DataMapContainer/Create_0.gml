/// @description map properties

event_inherited();

file_location = DataFileLocations.DATA;
data_buffer = noone;
contents = noone;
version = 0;

preview = noone;
wpreview = noone;
cspreview = noone;
cpreview = noone;

// A lot of the map metadata is stored in the MapContents object here, even
// though they're in the MapContainer in the game so that you can access
// properties of the map that isn't currently loaded. Here you don't really
// need that, and since they're stored in the data buffer, I'm not going to
// bother to read them out here for now.

// but there are some things that aren't.

xx = 64;                                  // dimensions
yy = 64;
zz = 8;

tileset = 0;                              // index
is_3d = true;

ds_list_add(Stuff.all_maps, id);