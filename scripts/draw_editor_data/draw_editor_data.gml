d3d_end();

draw_set_color(c_white);
draw_set_font(FDefault12);
draw_set_valign(fa_middle);

draw_clear(c_white);

script_execute(ui_game_data.render, ui_game_data, 0, 0);
