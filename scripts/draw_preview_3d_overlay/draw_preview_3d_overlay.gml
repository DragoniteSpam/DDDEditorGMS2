var w=__view_get( e__VW.WView, view_3d_preview );
var h=__view_get( e__VW.HView, view_3d_preview );
var lw=4;

d3d_set_projection_ortho(0, 0, w, h, 0);

draw_set_alpha(0.5);
draw_set_color(c_black);
draw_rectangle(16, 16, 400, 144, false);
draw_set_alpha(1);

d3d_set_culling(false)
draw_set_color(c_white);

draw_line_width_colour(0, 0, w, 0, lw, Stuff.setting_color, Stuff.setting_color);
draw_line_width_colour(0, 0, 0, h, lw, Stuff.setting_color, Stuff.setting_color);
draw_line_width_colour(w-1, 0, w-1, h, lw, Stuff.setting_color, Stuff.setting_color);
draw_line_width_colour(0, h-1, w, h-1, lw, Stuff.setting_color, Stuff.setting_color);

draw_set_font(FDefault12Bold);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_text(32, 32, string_hash_to_newline("Press Escape to close"));

if (keyboard_check(vk_shift)){
    draw_text(32, 64, string_hash_to_newline("Up/Down: translate across Z"));
    draw_text(32, 80, string_hash_to_newline("Left/Right: rotate around Z"));
} else if (keyboard_check(vk_control)){
    draw_text(32, 64, string_hash_to_newline("Up/Down: rotate around Y"));
    draw_text(32, 80, string_hash_to_newline("Left/Right: rotate around X"));
} else if (keyboard_check(vk_alt)){
    draw_text(32, 64, string_hash_to_newline("Up/Down: scale up/down (all axes)"));
} else {
    draw_text(32, 64, string_hash_to_newline("Up/Down: translate across Y"));
    draw_text(32, 80, string_hash_to_newline("Left/Right: translate across X"));
}

draw_text(32, 112, string_hash_to_newline("Press Backspace to reset"));
draw_text(32, 128, string_hash_to_newline("Shift, Control and Alt all do different things"));

draw_set_color(c_black);
