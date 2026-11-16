function ui_init_animation(mode) {
    var hud_width = window_get_width();
    var hud_height = window_get_height();
    var col1x = 32;
    var col2x = 288;
    var col3x = 544;
    var col_width = 240;
    var col_height = 32;
    
    var imgw = sprite_get_width(spr_timeline_keyframe_tween);
    var imgh = sprite_get_height(spr_timeline_keyframe_tween);

    var container = new EmuCore(0, 32, hud_width, hud_height);
    
    container.AddContent([
        new EmuText(32, 32, 1000, 32, "Old editor has been removed, if you ever come back to this, I'm sure it'll be much easier to remake one from scratch")
    ]);
    
    return container;
}
