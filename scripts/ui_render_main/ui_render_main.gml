/// @description void ui_render_main(UIMain);
/// @param UIMain

var ui_x=__view_get( e__VW.XView, view_hud );
var ui_y=__view_get( e__VW.YView, view_hud );
var ui_width=__view_get( e__VW.WView, view_hud );
var ui_height=__view_get( e__VW.HView, view_hud );

d3d_set_projection_ortho(ui_x, ui_y, ui_width, ui_height, 0);

draw_clear(c_white);
draw_set_color(c_black);
draw_set_font(FDefault12);
draw_set_valign(fa_middle);

// in this program there's going to be nothing in here, just
// tabs that are handled separately, but if you want persistent
// UI elements throw them in UIMain.contents
ui_render(argument0, 0, 0);

var xx=ui_x+32;
var yy=96;

var x1=xx;
var y1=yy;
var x2=x1+ui_legal_width();
var y2=y1+ui_legal_height();

var trow=argument0.tabs[| argument0.active_tab.home_row];
var ww=ui_legal_width()/ds_list_size(trow);
for (var i=0; i<ds_list_size(trow); i++) {
    var thing=trow[| i];
    thing.x=xx;
    thing.y=yy;
    thing.width=ww;
    xx=xx+ww;
}

for (var i=0; i<ds_list_size(argument0.tabs); i++) {
    if (i!=argument0.active_tab.home_row) {
        trow=argument0.tabs[| i];
        xx=ui_x+32;
        yy=yy-argument0.element_height;
        ww=ui_legal_width()/ds_list_size(trow);
        for (var j=0; j<ds_list_size(trow); j++) {
            var thing=trow[| j];
            thing.x=xx;
            thing.y=yy;
            thing.width=ww;
            xx=xx+ww;
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
for (var i=0; i<ds_list_size(argument0.tabs); i++) {
    trow=argument0.tabs[| i];
    for (var j=0; j<ds_list_size(trow); j++) {
        thing=trow[| j];
        // i think windows forms allow you to disable tabs, but i'm not
        // because that's a pain and i don't see it happening all that much
        script_execute(thing.render, thing, 0, 0);
    }
}

script_execute(argument0.active_tab.render_contents, argument0.active_tab, 0, 0);

if (mouse_within_view(view_hud)) {
    if (Controller.press_help) {
        ds_stuff_help_auto(argument0.active_tab);
    }
}

// either this script needs to be generic-ized for the ui_event tab, or the ui_event tab needs to
// be changed so that it also uses the view system (and things will still need to be generic-ized)
