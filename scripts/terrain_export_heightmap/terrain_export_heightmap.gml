/// @param filename

var fn = argument0;
var terrain = Stuff.terrain;

var buffer = buffer_create(buffer_sizeof(buffer_u32) * terrain.width * terrain.height, buffer_fixed, 1);

for (var i = 0; i < terrain.width; i++) {
    for (var j = 0; j < terrain.width; j++) {
        // if you want the image to be visible the alpha channel should be ignored, since you're not
        // going to make terrain high enough to actually reach those kinds of values
        var zz = (min(floor((terrain_get_z(terrain, i, j) + 256) * DEFAULT_TERRAIN_HEIGHTMAP_SCALE), 0x00ffffff) | 0xff000000);
        buffer_write(buffer, buffer_u32, zz);
    }
}

var surface = surface_create(terrain.width, terrain.height);
buffer_set_surface(buffer, surface, 0, 0, 0);
surface_save(surface, fn);
buffer_delete(buffer);
surface_free(surface);