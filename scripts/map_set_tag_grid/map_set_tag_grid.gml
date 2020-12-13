function map_set_tag_grid(x, y, z, tag, map) {
    if (map == undefined) map = Stuff.map.active_map;
    map.contents.map_grid_frozen_tags[@ x][@ y][@ z] = tag;
}