function dialog_create_preferences() {
    var dw = 640;
    var dh = 640;
    
    var dg = dialog_create(dw, dh, "Preferences", dialog_default, dc_close_no_questions_asked, undefined);
    
    var columns = 2;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;
    
    var col1_x = 16;
    var col2_x = dw / 2 + 16;
    
    var vx1 = dw / 4 + 16;
    var vy1 = 0;
    var vx2 = vx1 + 80;
    var vy2 = eh;
    
    var yy = 64;
    var yy_base = yy;
    
    var el_bezier = create_input(col1_x, yy, "Bezier precision:", ew, eh, function (input) {
        Settings.config.bezier_precision = real(input.value);
    }, Settings.config.bezier_precision, "0...16", validate_int, 1, 16, 2, vx1, vy1, vx2, vy2, dg);
    el_bezier.tooltip = "Higher-precision bezier curves look better, but take more computing power to draw. Lowering this will not fix performance issues, but it may help.";
    yy += el_bezier.height + spacing;
    
    var el_tooltips = create_checkbox(col1_x, yy, "Show Tooltips", ew, eh, function (checkbox) {
        Settings.config.tooltip = checkbox.value;
    }, Settings.config.tooltip, dg);
    el_tooltips.tooltip = "These thingies.";
    yy += el_tooltips.height + spacing;
    
    var el_npc_animation = create_input(col1_x, yy, "NPC speed:", ew, eh, function(input) {
        Settings.config.npc_animate_rate = real(input.value);
    }, Settings.config.npc_animate_rate, "0...9", validate_int, 1, 16, 2, vx1, vy1, vx2, vy2, dg);
    el_npc_animation.tooltip = "The speed at which NPC (Pawn) entities will animate.";
    yy += el_npc_animation.height + spacing;
    
    var el_ui_color = create_color_picker(col1_x, yy, "UI Color:", ew, eh, function(picker) {
        Settings.config.color = picker.value;
    }, Settings.config.color, vx1, vy1, vx2, vy2, dg);
    el_ui_color.tooltip = "The default color of the UI. I like green but you can make it something else if you don't like green.";
    yy += el_ui_color.height + spacing;
    
    var el_world_color = create_color_picker(col1_x, yy, "World Color:", ew, eh, function(picker) {
        Settings.config.color_world = picker.value;
    }, Settings.config.color_world, vx1, vy1, vx2, vy2, dg);
    el_world_color.tooltip = "The default background color of the game world. Using a skybox will (most likely) render this pointless.";
    yy += el_world_color.height + spacing;
    
    var el_camera_fly_text = create_text(col1_x, yy, "Camera Acceleration", ew, eh, fa_left, ew, dg);
    yy += el_camera_fly_text.height + spacing;
    
    var el_camera_fly = create_progress_bar(col1_x, yy, ew, eh, function (bar) {
        Settings.config.camera_fly_rate = normalize(progress.value, 0.5, 4, 0, 1);
    }, 4, normalize(Settings.config.camera_fly_rate, 0, 1, 0.5, 4), dg);
    el_camera_fly.tooltip = "How fast the camera accelerates in editor modes that use it (2D and 3D).";
    yy += el_camera_fly.height + spacing;
    
    var el_alt_middle = create_checkbox(col1_x, yy, "Alternate Middle Click", ew, eh, function(checkbox) {
        Settings.config.alternate_middle = checkbox.value;
    }, Settings.config.alternate_middle, dg);
    el_alt_middle.tooltip = "My mouse is slightly broken and middle click doesn't always work, so I need an alternate method to use it. This is turned off by default so that it's harder to accidentally invoke, but you may turn it on if you need it.\n\n(The alternate input is Control + Space.)";
    yy += el_alt_middle.height + spacing;
    
    var el_focus_alpha_text = create_text(col1_x, yy, "Out-of-focus opacity:", ew, eh, fa_left, ew, dg);
    yy += el_focus_alpha_text.height + spacing;
    
    var el_focus_alpha = create_progress_bar(col1_x, yy, ew, eh, function(progress) {
        Settings.config.focus_alpha = progress.value;
    }, 4, Settings.config.focus_alpha, dg);
    yy += el_focus_alpha.height + spacing;
    
    yy = yy_base;
    
    var el_code_ext = create_radio_array(col2_x + col1_x, yy, "Code File Extension:", ew, eh, function(radio) {
        Settings.config.code_extension = radio.value;
    }, Settings.config.code_extension, dg);
    el_code_ext.tooltip = "This only really affects the text editor you want to be able to edit Lua code with. Plain text files will open with Notepad by default, but if you have another editor set such as Notepad++ you can use that instead.";
    create_radio_array_options(el_code_ext, Stuff.code_extension_map);
    
    yy += ui_get_radio_array_height(el_code_ext) + spacing;
    
    var el_text_ext = create_radio_array(col2_x + col1_x, yy, "Text File Extension:", ew, eh, function(radio) {
        Settings.config.text_extension = radio.value;
    }, Settings.config.text_extension, dg);
    el_text_ext.tooltip = "This only really affects the text editor you want to be able to edit text files with. Plain text files will open with Notepad by default, but if you have another editor set such as Notepad++ you can use that instead.";
    create_radio_array_options(el_text_ext, Stuff.text_extension_map);
    
    yy += ui_get_radio_array_height(el_text_ext) + spacing;
    
    var b_width = 128;
    var b_height = 32;
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
    
    ds_list_add(dg.contents,
        el_bezier,
        el_tooltips,
        el_npc_animation,
        el_ui_color,
        el_world_color,
        el_camera_fly_text,
        el_camera_fly,
        el_alt_middle,
        el_code_ext,
        el_text_ext,
        el_focus_alpha_text,
        el_focus_alpha,
        el_confirm
    );
    
    return dg;
}