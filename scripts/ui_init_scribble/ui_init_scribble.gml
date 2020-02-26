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
    
    var xx_in = xx + ew / 3;
    var xx_out = xx + ew * 2 / 3;
    
    var element = create_text(xx, yy, "Text to preview:", ew, eh, fa_left, ew, id);
    ds_list_add(contents, element);
    
    var element = create_button(xx_in, yy, "Copy", ew / 3, eh, fa_center, uivc_scribble_text_copy, id);
    ds_list_add(contents, element);
    
    var element = create_button(xx_out, yy, "Paste", ew / 3, eh, fa_center, uivc_scribble_text_paste, id);
    ds_list_add(contents, element);
    
    yy = yy + element.height + spacing;
    
    var vx1 = 0;
    var vy1 = 0;
    var vx2 = vx1 + ew;
    var vy2 = vy1 + eh * 12;
    
    var element = create_input(xx, yy, "", ew, eh, uivc_scribble_text, mode.scribble_text, "text", validate_string, 0, 1, 10000, vx1, vy1, vx2, vy2, id);
    element.multi_line = true;
    el_scribble_text = element;
    ds_list_add(contents, element);
    
    yy = yy + element.height + vy2;
    
    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = vy1 + eh;
    
    var element = create_text(xx, yy, "Autotype", ew, eh, fa_left, ew, id);
    element.color = c_blue;
    ds_list_add(contents, element);
    
    var element = create_text(xx_in, yy, "In", ew, eh, fa_left, ew, id);
    ds_list_add(contents, element);
    
    var element = create_text(xx_out, yy, "Out", ew, eh, fa_left, ew, id);
    ds_list_add(contents, element);
    
    yy = yy + element.height + spacing;
    
    var element = create_text(xx, yy, "    Method:", ew, eh, fa_left, ew, id);
    ds_list_add(contents, element);
    
    var element = create_radio_array(xx_in, yy - element.height, "", ew, eh, uivc_scribble_text_autotype_in_method, mode.scribble_autotype_in_method, id);
    create_radio_array_options(element, ["None", "Per Character", "Per Line"])
    element.tooltip = "The autotype method used. Scribble allows you to fade text by character or by line.";
    ds_list_add(contents, element);
    
    var element = create_radio_array(xx_out, yy - element.height, "", ew, eh, uivc_scribble_text_autotype_out_method, mode.scribble_autotype_out_method, id);
    create_radio_array_options(element, ["None", "Per Character", "Per Line"])
    element.tooltip = "The autotype method used. Scribble allows you to fade text by character or by line.";
    ds_list_add(contents, element);
    
    yy = yy + ui_get_radio_array_height(element);
    
    var element = create_text(xx, yy, "    Speed:", ew, eh, fa_left, ew, id);
    ds_list_add(contents, element);
    
    var vx1 = spacing;
    var vy1 = 0;
    var vx2 = ew / 3;
    var vy2 = vy1 + eh;
    
    var element = create_input(xx_in, yy, "", ew, eh, uivc_scribble_text_autotype_in_speed, mode.scribble_autotype_in_speed, "float", validate_double, 0.1, 1000, 4, vx1, vy1, vx2, vy2, id);
    element.tooltip = "The speed at which text is revealed when autotype is enabled.";
    ds_list_add(contents, element);
    
    var element = create_input(xx_out, yy, "", ew, eh, uivc_scribble_text_autotype_out_speed, mode.scribble_autotype_out_speed, "float", validate_double, 0.1, 1000, 4, vx1, vy1, vx2, vy2, id);
    element.tooltip = "The speed at which text is concealed when autotype is enabled.";
    ds_list_add(contents, element);
    
    yy = yy + element.height + spacing;
    
    var element = create_text(xx, yy, "    Smoothness:", ew, eh, fa_left, ew, id);
    ds_list_add(contents, element);
    
    var element = create_input(xx_in, yy, "", ew, eh, uivc_scribble_text_autotype_in_smoothness, mode.scribble_autotype_in_smoothness, "float", validate_double, 0.1, 1000, 4, vx1, vy1, vx2, vy2, id);
    element.tooltip = "How smoothly characters fade in when autotype is running. Higher values correspond to a longer fade time; a smoothness value of 1 means characters appear instantly.";
    ds_list_add(contents, element);
    
    var element = create_input(xx_out, yy, "", ew, eh, uivc_scribble_text_autotype_out_smoothness, mode.scribble_autotype_out_smoothness, "float", validate_double, 0.1, 1000, 4, vx1, vy1, vx2, vy2, id);
    element.tooltip = "How smoothly characters fade out when autotype is running. Higher values correspond to a longer fade time; a smoothness value of 1 means characters appear instantly.";
    ds_list_add(contents, element);
    
    yy = yy + element.height + spacing;
    
    var element = create_text(xx, yy, "    Delay:", ew, eh, fa_left, ew, id);
    ds_list_add(contents, element);
    
    var element = create_input(xx_in, yy, "", ew, eh, uivc_scribble_text_autotype_in_delay, mode.scribble_autotype_in_delay, "float", validate_double, 0.1, 1000, 4, vx1, vy1, vx2, vy2, id);
    element.tooltip = "The amount of time between when the text finishes fading out and when the text begins fading in";
    ds_list_add(contents, element);
    
    var element = create_input(xx_out, yy, "", ew, eh, uivc_scribble_text_autotype_out_delay, mode.scribble_autotype_out_delay, "float", validate_double, 0.1, 1000, 4, vx1, vy1, vx2, vy2, id);
    element.tooltip = "The amount of time between when the text finishes fading in and when the text begins fading out";
    ds_list_add(contents, element);
    
    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = vy1 + eh;
    
    yy = yy + element.height + spacing;
    
    var element = create_text(xx, yy, "Other Parameters", ew, eh, fa_left, ew, id);
    element.color = c_blue;
    ds_list_add(contents, element);
    
    yy = yy + element.height + spacing;
    
    var element = create_text(xx, yy, "Text bounds:", ew, eh, fa_left, ew, id);
    ds_list_add(contents, element);
    
    var element = create_progress_bar(xx + ew / 2, yy, ew / 2, eh, uivc_scribble_text_bounds_width, 4, mode.scribble_bounds_width, id);
    element.tooltip = "The width of the bounding box containing the text.";
    ds_list_add(contents, element);
    
    yy = yy + element.height + spacing;
    
    var element = create_color_picker(xx, yy, "Default color:", ew / 2, eh, uivc_scribble_default_colour, mode.scribble_default_colour, vx1, vy1, vx2, vy2, id);
    ds_list_add(contents, element);
    
    yy = yy + element.height + spacing;

    var element = create_text(xx, yy, "Assistance", ew, eh, fa_left, ew, id);
    element.color = c_blue;
    ds_list_add(contents, element);
    
    yy = yy + element.height + spacing;
    
    var element = create_button(xx, yy, "Available Colors", ew / 2 - spacing, eh, fa_center, uivc_scribble_available_colors, id);
    element.tooltip = "Define colors recognized by Scribble.";
    ds_list_add(contents, element);
    
    var element = create_button(xx + ew / 2 + spacing, yy, "Fonts", ew / 2 - spacing, eh, fa_center, uivc_scribble_available_fonts, id);
    element.tooltip = "Fonts recognized by Scribble. In the future you may be allowed to import your own, but that is not a guarantee.";
    ds_list_add(contents, element);
    
    yy = yy + element.height + spacing;
    #endregion
    
    #region scribble canvas
    var this_column = 1;
    var xx = this_column * cw + spacing;
    yy = yy_base;
    
    var xx_colour = xx;
    var xx_grid = xx + ew / 2;
    
    var vx1 = ew / 4;
    var vy1 = 0;
    var vx2 = ew / 2;
    var vy2 = vy1 + eh;
    
    var element = create_color_picker(xx_colour, yy, "Background:", ew / 2, eh, uivc_scribble_background_colour, mode.scribble_back_colour, vx1, vy1, vx2, vy2, id);
    ds_list_add(contents, element);
    
    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = vy1 + eh;
    
    var element = create_checkbox(xx_grid, yy, "Show grid", ew / 2, eh, uivc_scribble_show_grid, mode.scribble_back_show_grid, id);
    ds_list_add(contents, element);
    
    yy = yy + element.height + spacing;
    
    var element = create_render_surface(xx, yy, room_width - spacing * 2 - xx, room_height - spacing * 2 - yy, ui_render_surface_scribble_preview, null, id);
    ds_list_add(contents, element);
    #endregion
    
    return id;
}