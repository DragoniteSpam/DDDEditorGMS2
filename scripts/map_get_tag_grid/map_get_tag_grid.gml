function map_get_tag_grid(x, y, z) {
    return Stuff.map.active_map.contents.map_grid_frozen_tags[# x, y][@ z];
}