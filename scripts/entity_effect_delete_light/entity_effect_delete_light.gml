/// @param EntityEffect

var effect = argument0;

var map = Stuff.map.active_map;
var map_contents = map.contents;

ds_list_delete(map_contents.all_entities, ds_list_find_index(map_contents.all_entities, effect));