if (Stuff.is_quitting) exit;

entity_destroy();

Stuff.map.active_map.contents.population[ETypes.ENTITY_EFFECT]--;

var map = Stuff.map.active_map;
var map_contents = map.contents;

var light_index = ds_list_find_index(map_contents.active_lights, REFID);
if (light_index != -1) {
    map_contents.active_lights[| light_index] = noone;
}