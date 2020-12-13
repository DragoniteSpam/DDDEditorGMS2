function map_get_tag_grid(x, y, z, map) {
    if (map == undefined) map = Stuff.map.active_map;
    return map.contents.map_grid_frozen_tags[x][y][z];
}