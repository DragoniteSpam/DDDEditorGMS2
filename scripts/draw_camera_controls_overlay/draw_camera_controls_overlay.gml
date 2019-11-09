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
    mode.x = 0;
    mode.y = 0;
    mode.z = 100;
    
    mode.xto = 512;
    mode.yto = 512;
    mode.zto = 0;
    
    mode.xup = 0;
    mode.yup = 0;
    mode.zup = 1;
}