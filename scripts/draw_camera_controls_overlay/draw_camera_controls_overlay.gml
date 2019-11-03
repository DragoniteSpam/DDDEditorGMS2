var iconx = 32;
var icony = view_get_yport(view_current) + view_get_hport(view_current) - 32;
var iconlength = 16;

var inbounds = mouse_within_rectangle_view(iconx - iconlength, icony - iconlength, iconx + iconlength, icony + iconlength);
var c = inbounds ? c_ui_select : c_white;
draw_roundrect_colour(iconx - iconlength, icony - iconlength, iconx + iconlength, icony + iconlength, c, c, false);
draw_roundrect_colour(iconx - iconlength, icony - iconlength, iconx + iconlength, icony + iconlength, c_black, c_black, true);
draw_sprite(spr_camera_icons, 2, iconx - sprite_get_width(spr_camera_icons) / 2, icony - sprite_get_height(spr_camera_icons) / 2);

if ((inbounds && Controller.release_left) || keyboard_check(vk_f1)) {
    Camera.x = 0;
    Camera.y = 0;
    Camera.z = 100;
    
    Camera.xto = 512;
    Camera.yto = 512;
    Camera.zto = 0;
    
    Camera.xup = 0;
    Camera.yup = 0;
    Camera.zup = 1;
}