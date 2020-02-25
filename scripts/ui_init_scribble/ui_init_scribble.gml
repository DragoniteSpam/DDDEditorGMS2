/// @param EditorModeScribble

var mode = argument0;

// this one's not tabbed, it's just a bunch of elements floating in space
with (instance_create_depth(0, 0, 0, UIThing)) {
    var columns = 3;
    var spacing = 16;
    
    var cw = (room_width - columns * 32) / columns;
    var ew = cw - spacing * 2;
    var eh = 24;
    
    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = vy1 + eh;
    
    var b_width = 128;
    var b_height = 32;
    
    var yy_header = 64;
    var yy = 64 + eh;
    var yy_base = yy;
    
    #region scribble control
    var this_column = 0;
    var xx = this_column * cw + spacing;
    
    var element = create_text(xx, yy, "Text to preview:", ew, eh, fa_left, ew, id);
    ds_list_add(contents, element);
    
    yy = yy + element.height + spacing;
    
    var vx1 = 0;
    var vy1 = 0;
    var vx2 = vx1 + ew;
    var vy2 = vy1 + eh * 12;
    
    var element = create_input(xx, yy, "", ew, eh, uivc_scribble_text, mode.scribble_text, "text", validate_string, 0, 1, 10000, vx1, vy1, vx2, vy2, id);
    element.multi_line = true;
    ds_list_add(contents, element);
    
    yy = yy + element.height + vy2;
    
    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = vy1 + eh;
    
    var element = create_checkbox(xx, yy, "Autotype", ew, eh, null, mode.scribble_autotype_enabled, id);
    element.tooltip = "Turns the autotype effect on or off. If running, autotype will be restarted every time you change the preview text; you may wish to turn it off while entering text.";
    ds_list_add(contents, element);
    
    yy = yy + element.height + spacing;
    
    var element = create_radio_array(xx, yy, "    Method", ew, eh, null, mode.scribble_autotype_method, id);
    create_radio_array_options(element, ["Per Character", "Per Line"])
    element.tooltip = "The autotype method used. Scribble allows you to fade in text by character or by line.";
    element.interactive = mode.scribble_autotype_enabled;
    autotype_method = element;
    ds_list_add(contents, element);
    
    yy = yy + ui_get_radio_array_height(element) + spacing;
    
    var element = create_input(xx, yy, "    Speed", ew, eh, null, mode.scribble_autotype_speed, "float", validate_double, 0.1, 1000, 4, vx1, vy1, vx2, vy2, id);
    element.tooltip = "The speed at which text is revealed when autotype is enabled.";
    element.interactive = mode.scribble_autotype_enabled;
    autotype_speed = element;
    ds_list_add(contents, element);
    
    yy = yy + element.height + spacing;
    
    var element = create_input(xx, yy, "    Smoothness", ew, eh, null, mode.scribble_autotype_smoothness, "float", validate_double, 0.1, 1000, 4, vx1, vy1, vx2, vy2, id);
    element.tooltip = "Whether characters fade in smoothly when autotype is running. Higher values correspond to a longer fade time; a smoothness value of 1 means characters appear instantly.";
    element.interactive = mode.scribble_autotype_enabled;
    autotype_smoothness = element;
    ds_list_add(contents, element);
    
    yy = yy + element.height + spacing;
    
    var element = create_text(xx, yy, "Text bounds:", ew, eh, fa_left, ew, id);
    ds_list_add(contents, element);
    
    var element = create_progress_bar(xx + ew / 2, yy, ew / 2, eh, null, 4, mode.scribble_bounds_width, id);
    element.tooltip = "The width of the bounding box containing the text.";
    ds_list_add(contents, element);
    
    yy = yy + element.height + spacing;
    
    var element = create_button(xx, yy, "Colors", ew / 2 - spacing, eh, fa_center, null, id);
    element.tooltip = "Define colors recognized by Scribble.";
    ds_list_add(contents, element);
    
    var element = create_button(xx + ew / 2 + spacing, yy, "Fonts", ew / 2 - spacing, eh, fa_center, null, id);
    element.tooltip = "Define fonts recognized by Scribble.";
    ds_list_add(contents, element);
    
    yy = yy + element.height + spacing;
    #endregion
    
    #region scribble canvas
    var this_column = 1;
    var xx = this_column * cw + spacing;
    yy = yy_base;
    
    var element = create_text(xx, yy, "Scribble output:", ew, eh, fa_left, ew, id);
    ds_list_add(contents, element);
    
    yy = yy + element.height + spacing;
    
    var element = create_render_surface(xx, yy, room_width - spacing * 2 - xx, room_height - spacing * 2 - yy, ui_render_surface_scribble_preview, null, id);
    ds_list_add(contents, element);
    #endregion
    
    return id;
}