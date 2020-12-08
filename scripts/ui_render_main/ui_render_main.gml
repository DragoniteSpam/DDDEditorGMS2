/// @param UIMain
function ui_render_main(argument0) {

    var ui = argument0;

    var camera = view_get_camera(view_current);
    var ui_x = camera_get_view_x(camera);
    var ui_y = camera_get_view_x(camera);
    var ui_width = camera_get_view_width(camera);
    var ui_height = camera_get_view_height(camera);

    camera_set_view_mat(camera, matrix_build_lookat(ui_x + ui_width / 2, ui_y + ui_height / 2, -16000,  ui_x + ui_width / 2, ui_y + ui_height / 2, 0, 0, 1, 0));
    camera_set_proj_mat(camera, matrix_build_projection_ortho(ui_width, ui_height, CAMERA_ZNEAR, CAMERA_ZFAR));
    camera_apply(camera);

    draw_clear(c_white);
    draw_set_color(c_black);
    draw_set_font(FDefault12);
    draw_set_valign(fa_middle);

    // in this program there's going to be nothing in here, just
    // tabs that are handled separately, but if you want persistent
    // UI elements throw them in UIMain.contents
    ui_render(ui, 0, 0);

    var xx = ui_x + 32;
    var yy = ui.home_row_y;

    var x1 = xx;
    var y1 = yy;
    var x2 = x1 + ui_legal_width();
    var y2 = y1 + ui_legal_height(ui);

    var trow = ui.tabs[| ui.active_tab.home_row];
    var ww = ui_legal_width() / ds_list_size(trow);
    for (var i=0; i<ds_list_size(trow); i++) {
        var thing = trow[| i];
        thing.x = xx;
        thing.y = yy;
        thing.width = ww;
        xx = xx + ww;
    }

    for (var i = 0; i < ds_list_size(ui.tabs); i++) {
        if (i != ui.active_tab.home_row) {
            trow = ui.tabs[| i];
            xx = ui_x + 32;
            yy = yy - ui.element_height;
            ww = ui_legal_width() / ds_list_size(trow);
            for (var j = 0; j < ds_list_size(trow); j++) {
                var thing = trow[| j];
                thing.x = xx;
                thing.y = yy;
                thing.width = ww;
                xx = xx + ww;
            }
        }
    }

    draw_line(x1, y1, x1, y2);
    draw_line(x2, y1, x2, y2);
    draw_line(x1, y2, x2, y2);

    // this is annoying but if you process the tabs in the order
    // that they're laid out you can run into some issues where
    // their position updates before the rest have been drawn if
    // you click on them
    for (var i = 0; i < ds_list_size(ui.tabs); i++) {
        trow = ui.tabs[| i];
        for (var j = 0; j < ds_list_size(trow); j++) {
            thing = trow[| j];
            // i think windows forms allow you to disable tabs, but i'm not
            // because that's a pain and i don't see it happening all that much
            thing.render(thing, 0, 0);
        }
    }

    ui.active_tab.render_contents(ui.active_tab, 0, 0);

    ui_handle_dropped_files(ui);


}
