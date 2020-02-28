/// @param UIRadioArray

var radio = argument0;
var base_dialog = radio.root.root;

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