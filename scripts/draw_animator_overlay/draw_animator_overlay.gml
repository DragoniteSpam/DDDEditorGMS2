var w = view_get_wport(view_current)
var h = view_get_hport(view_current);
var lw = 4;

d3d_set_projection_ortho(0, 0, w, h, 0);

gpu_set_cullmode(cull_noculling);
draw_set_alpha(0.75);
draw_set_color(c_black);
draw_rectangle(0, 0, w, 48, false);
draw_set_alpha(1);

draw_set_font(FDefault12Bold);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_color(c_white);

draw_text(16, 16, "Lua and the spart systems are paid assets, so I'm not including them in this editor.");
draw_text(16, 32, "In the future I may make a workaround for this, but for now they just won't be shown.");

draw_set_color(c_black);