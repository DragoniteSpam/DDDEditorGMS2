/// @param [map]
function map_clear_tag_grid() {

    var map = (argument_count > 0) ? argument[0] : Stuff.map.active_map;
    var map_contents = map.contents;

    ds_grid_destroy(map_contents.map_grid_frozen_tags);
    map_contents.map_grid_frozen_tags = map_create_tag_grid(map.xx, map.yy, map.zz);


}
