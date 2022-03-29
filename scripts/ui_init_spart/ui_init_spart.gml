function ui_init_spart() {
    var hud_width = window_get_width();
    var hud_height = window_get_height();
    var col1x = 1080 + 32;
    var col2x = 1080 + 288;
    var col_width = 240;
    var col_height = 32;
    
    var container = new EmuCore(0, 32, hud_width, hud_height);
    container.active_animation = undefined;
    container.active_layer = undefined;
    
    container.AddContent([
        (new EmuRenderSurface(0, 0, 1080, hud_height, function(mx, my) {
            Stuff.spart.DrawSpart();
        }, function(mx, my) {
            
        }))
            .SetID("3D VIEW")
    ]);
    
    return container;
}