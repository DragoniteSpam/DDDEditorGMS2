/// @param map

var map = argument0;

if (map.run_init) {
    var light = instance_create_depth(0, 0, 0, EntityEffect);
    light.com_light = instance_create_depth(0, 0, 0, EffectComponentDirectionalLight);
    light.com_light.parent = light;
    instance_deactivate_object(light);
    map_add_thing(light, 0, 0, 0);
    map.run_init = false;
}