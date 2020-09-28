function map_get_free_at(x, y, z, slot) {
    return (Stuff.map.active_map.contents.map_grid[# x, y][@ z][@ slot] == noone);
}