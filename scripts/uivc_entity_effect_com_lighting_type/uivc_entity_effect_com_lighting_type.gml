/// @param UIRadioArray

var radio = argument0;
var base_dialog = radio.root.root;
var list = Stuff.map.selected_entities;

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
        base_dialog.el_point_x.enabled = false;
        base_dialog.el_point_y.enabled = false;
        base_dialog.el_point_z.enabled = false;
        base_dialog.el_point_radius.enabled = false;
        break;
    case LightTypes.DIRECTIONAL:
        base_dialog.el_color.enabled = true;
        base_dialog.el_dir_x.enabled = true;
        base_dialog.el_dir_y.enabled = true;
        base_dialog.el_dir_z.enabled = true;
        base_dialog.el_point_x.enabled = false;
        base_dialog.el_point_y.enabled = false;
        base_dialog.el_point_z.enabled = false;
        base_dialog.el_point_radius.enabled = false;
        
        for (var i = 0; i < ds_list_size(list); i++) {
            var effect = list[| i];
            effect.com_light = instance_create_depth(0, 0, 0, EffectComponentDirectionalLight);
            instance_deactivate_object(effect.com_light);
        }
        break;
    case LightTypes.POINT:
        base_dialog.el_color.enabled = true;
        base_dialog.el_dir_x.enabled = false;
        base_dialog.el_dir_y.enabled = false;
        base_dialog.el_dir_z.enabled = false;
        base_dialog.el_point_x.enabled = true;
        base_dialog.el_point_y.enabled = true;
        base_dialog.el_point_z.enabled = true;
        base_dialog.el_point_radius.enabled = true;
        
        for (var i = 0; i < ds_list_size(list); i++) {
            var effect = list[| i];
            effect.com_light = instance_create_depth(0, 0, 0, EffectComponentPointLight);
            instance_deactivate_object(effect.com_light);
        }
        break;
    case LightTypes.SPOT:
        base_dialog.el_color.enabled = true;
        base_dialog.el_dir_x.enabled = false;
        base_dialog.el_dir_y.enabled = false;
        base_dialog.el_dir_z.enabled = false;
        base_dialog.el_point_x.enabled = false;
        base_dialog.el_point_y.enabled = false;
        base_dialog.el_point_z.enabled = false;
        base_dialog.el_point_radius.enabled = false;
        break;
}