/// @param UIRadioArray

var radio = argument0;
var base_dialog = radio.root.root;
var list = Stuff.map.selected_entities;
// it doesn't actually matter if more than one effect entities are selected or not
// here because they'll all have the same parameters after you set the type anyway,
// but i don't want people to forget that they have more than one thing selected
var single = (ds_list_size(list) == 1);
var first = list[| 0];

for (var i = 0; i < ds_list_size(list); i++) {
    var effect = list[| i];
    if (effect.com_light) {
        instance_activate_object(effect.com_light);
        instance_destroy(effect.com_light);
        effect.com_light = noone;
    }
}

switch (radio.value) {
    case LightTypes.NONE:
        base_dialog.el_color.enabled = false;
        base_dialog.el_dir_x.enabled = false;
        base_dialog.el_dir_y.enabled = false;
        base_dialog.el_dir_z.enabled = false;
        base_dialog.el_point_radius.enabled = false;
        break;
    case LightTypes.DIRECTIONAL:
        base_dialog.el_color.enabled = true;
        base_dialog.el_dir_x.enabled = true;
        base_dialog.el_dir_y.enabled = true;
        base_dialog.el_dir_z.enabled = true;
        base_dialog.el_point_radius.enabled = false;
        
        for (var i = 0; i < ds_list_size(list); i++) {
            var effect = list[| i];
            effect.com_light = instance_create_depth(0, 0, 0, EffectComponentDirectionalLight);
            instance_deactivate_object(effect.com_light);
            effect.com_light.parent = effect;
        }
        
        base_dialog.el_color.value = first.com_light.light_colour;
        ui_input_set_value(base_dialog.el_dir_x, string(single ? first.com_light.light_dx : "-"));
        ui_input_set_value(base_dialog.el_dir_y, string(single ? first.com_light.light_dy : "-"));
        ui_input_set_value(base_dialog.el_dir_z, string(single ? first.com_light.light_dz : "-"));
        break;
    case LightTypes.POINT:
        base_dialog.el_color.enabled = true;
        base_dialog.el_dir_x.enabled = false;
        base_dialog.el_dir_y.enabled = false;
        base_dialog.el_dir_z.enabled = false;
        base_dialog.el_point_radius.enabled = true;
        
        for (var i = 0; i < ds_list_size(list); i++) {
            var effect = list[| i];
            effect.com_light = instance_create_depth(0, 0, 0, EffectComponentPointLight);
            instance_deactivate_object(effect.com_light);
            effect.com_light.parent = effect;
        }
        
        base_dialog.el_color.value = first.com_light.light_colour;
        ui_input_set_value(base_dialog.el_point_radius, string(single ? first.com_light.light_radius : "-"));
        break;
    case LightTypes.SPOT:
        base_dialog.el_color.enabled = true;
        base_dialog.el_dir_x.enabled = false;
        base_dialog.el_dir_y.enabled = false;
        base_dialog.el_dir_z.enabled = false;
        base_dialog.el_point_radius.enabled = false;
        break;
}