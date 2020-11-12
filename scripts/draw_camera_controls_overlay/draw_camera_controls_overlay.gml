function draw_camera_controls_overlay() {
    var iconx = 32;
    var icony = view_get_yport(view_current) + view_get_hport(view_current) - 32;
    var iconlength = 16;
    
    var inbounds = mouse_within_rectangle_view(iconx - iconlength, icony - iconlength, iconx + iconlength, icony + iconlength);
    var c = inbounds ? c_ui_select : c_white;
    draw_roundrect_colour(iconx - iconlength, icony - iconlength, iconx + iconlength, icony + iconlength, c, c, false);
    draw_roundrect_colour(iconx - iconlength, icony - iconlength, iconx + iconlength, icony + iconlength, c_black, c_black, true);
    draw_sprite(spr_camera_icons, 2, iconx - sprite_get_width(spr_camera_icons) / 2, icony - sprite_get_height(spr_camera_icons) / 2);
    
    if ((inbounds && Controller.release_left) || keyboard_check(vk_f1)) {
        x = def_x;
        y = def_y;
        z = def_z;
        
        xto = def_xto;
        yto = def_yto;
        zto = def_zto;
        
        xup = def_xup;
        yup = def_yup;
        zup = def_zup;
        
        fov = def_fov;
        pitch = darctan2(z - zto, point_distance(x, y, xto, yto));
        direction = point_direction(x, y, xto, yto);
    }
}