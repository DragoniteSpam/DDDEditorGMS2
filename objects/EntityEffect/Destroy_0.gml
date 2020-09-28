if (Stuff.is_quitting) exit;

Stuff.map.active_map.contents.population[ETypes.ENTITY_EFFECT]--;

var map = Stuff.map.active_map;
var map_contents = map.contents;

var light_index = ds_list_find_index(map_contents.active_lights, REFID);
if (light_index != -1) {
    map_contents.active_lights[| light_index] = noone;
}

instance_activate_object(cobject_x_axis);
instance_activate_object(cobject_y_axis);
instance_activate_object(cobject_z_axis);
instance_activate_object(cobject_x_plane);
instance_activate_object(cobject_y_plane);
instance_activate_object(cobject_z_plane);
instance_destroy(cobject_x_axis);
instance_destroy(cobject_y_axis);
instance_destroy(cobject_z_axis);
instance_destroy(cobject_x_plane);
instance_destroy(cobject_y_plane);
instance_destroy(cobject_z_plane);