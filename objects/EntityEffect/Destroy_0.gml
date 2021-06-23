if (Stuff.is_quitting) exit;

Stuff.map.active_map.contents.population[ETypes.ENTITY_EFFECT]--;

var map = Stuff.map.active_map;
var map_contents = map.contents;

var light_index = array_search(map_contents.active_lights, REFID);
if (light_index != -1) {
    map_contents.active_lights[@ light_index] = NULL;
}

cobject_x_axis.Destroy();
cobject_y_axis.Destroy();
cobject_z_axis.Destroy();
cobject_x_plane.Destroy();
cobject_y_plane.Destroy();
cobject_z_plane.Destroy();