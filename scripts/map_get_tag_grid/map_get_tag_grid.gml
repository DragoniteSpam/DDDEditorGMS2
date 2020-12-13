function map_get_tag_grid(x, y, z) {
    var map = Stuff.map.active_map;
    return map.contents.map_grid_tags[x][y][z];
}