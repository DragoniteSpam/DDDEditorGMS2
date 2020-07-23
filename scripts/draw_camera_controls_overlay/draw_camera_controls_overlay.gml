/// @param EditorMode

var mode = argument0;

var iconx = 32;
var icony = view_get_yport(view_current) + view_get_hport(view_current) - 32;
var iconlength = 16;

var inbounds = mouse_within_rectangle_view(iconx - iconlength, icony - iconlength, iconx + iconlength, icony + iconlength);
var c = inbounds ? c_ui_select : c_white;
draw_roundrect_colour(iconx - iconlength, icony - iconlength, iconx + iconlength, icony + iconlength, c, c, false);
draw_roundrect_colour(iconx - iconlength, icony - iconlength, iconx + iconlength, icony + iconlength, c_black, c_black, true);
draw_sprite(spr_camera_icons, 2, iconx - sprite_get_width(spr_camera_icons) / 2, icony - sprite_get_height(spr_camera_icons) / 2);

if ((inbounds && Controller.release_left) || keyboard_check(vk_f1)) {
    mode.x = mode.def_x;
    mode.y = mode.def_y;
    mode.z = mode.def_z;
    
    mode.xto = mode.def_xto;
    mode.yto = mode.def_yto;
    mode.zto = mode.def_zto;
    
    mode.xup = mode.def_xup;
    mode.yup = mode.def_yup;
    mode.zup = mode.def_zup;
    
    mode.fov = mode.def_fov;
    mode.pitch = arctan2(mode.z, point_distance(0, 0, mode.x, mode.y));
    mode.direction = point_direction(mode.x, mode.y, 0, 0);
}