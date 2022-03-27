function draw_camera_controls_overlay() {
    var iconx = 32;
    var icony = window_get_height() - 32;
    var iconlength = 16;
    
    var inbounds = mouse_within_rectangle(iconx - iconlength, icony - iconlength, iconx + iconlength, icony + iconlength);
    var c = inbounds ? c_ui_select : c_white;
    draw_roundrect_colour(iconx - iconlength, icony - iconlength, iconx + iconlength, icony + iconlength, c, c, false);
    draw_roundrect_colour(iconx - iconlength, icony - iconlength, iconx + iconlength, icony + iconlength, c_black, c_black, true);
    draw_sprite(spr_camera_icons, 2, iconx - sprite_get_width(spr_camera_icons) / 2, icony - sprite_get_height(spr_camera_icons) / 2);
    
    if ((inbounds && Controller.release_left) || keyboard_check(vk_f1)) {
        self.camera.Reset();
    }
}