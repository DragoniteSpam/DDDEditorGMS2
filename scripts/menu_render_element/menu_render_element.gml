/// @description void menu_render_element(MenuMenu, x, y, x2, y2);
/// @param MenuMenu
/// @param x
/// @param y
/// @param x2
/// @param y2

// the root menu objects calculate their x2 and y2 based on
// their width and height, but since the width and height of
// menu elements are based on their neighbors, we just pass
// them as parameters
var x1=argument1;
var y1=argument2;
var x2=argument3;
var y2=argument4;

argument0.x=x1;
argument0.y=y1;

var tx=ui_get_text_x(argument0, x1, x2);
var ty=ui_get_text_y(argument0, y1, y2);

var active=menu_is_active(argument0);

// click on the element
if (mouse_within_rectangle(x1, y1, x2, y2)||active) {
    draw_rectangle_colour(x1, y1, x2, y2, c_ui, c_ui, c_ui, c_ui, false);
}
if (mouse_within_rectangle(x1, y1, x2, y2)) {
    if (get_release_left()&&!dialog_exists()) {
        script_execute(argument0.onmouseup, argument0);
    }
}

draw_set_halign(argument0.alignment);
draw_set_valign(argument0.valignment);
draw_set_color(argument0.color);
draw_text(tx, ty, string(argument0.text));

if (argument0.onmouseup==momu_expand) {
    var s=5;
    draw_triangle(x2-s*2, ty-s, x2-s, ty, x2-s*2, ty+s, false);
}

if (active) {
    var separation=16;
    var ww=separation*2;
    for (var i=0; i<ds_list_size(argument0.contents); i++) {
        var ew=string_width(string(argument0.contents[| i].text));
        if (argument0.contents[| i].onmouseup==momu_expand) {
            ew=ew+16;
        }
        ww=max(ww, ew+separation*2);
    }
    // todo limit hh and add a scroll bar if it flows offscreen
    var hh=argument0.height*ds_list_size(argument0.contents)+separation*2;
    var xx=x2;
    if (xx+ww>CW) {
        xx=CW-ww;
    }
    var yy=y1;
    if (yy+hh>CH) {
        yy=CH-hh;
    }
    draw_rectangle_colour(xx, yy, xx+ww, yy+hh, c_white, c_white, c_white, c_white, false);
    for (var i=0; i<ds_list_size(argument0.contents); i++) {
        var thing=argument0.contents[| i];
        if (thing.enabled) {
            var mx1=xx;
            var my1=yy+argument0.height*i+separation
            var mx2=mx1+ww;
            var my2=my1+argument0.height;
            script_execute(thing.render, thing, mx1, my1, mx2, my2);
        }
    }
}
