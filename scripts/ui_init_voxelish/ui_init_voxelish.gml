function ui_init_voxelish(mode) {
    var hud_start_x = 1080;
    var hud_start_y = 0;
    var hud_width = room_width - hud_start_x;
    var hud_height = room_height;
    var col1x = 32;
    var col2x = 272;
    var col_width = 216;
    
    var container = new EmuCore(0, 0, hud_width, hud_height);
    
    container.AddContent([
    ]);
    
    return container;
}