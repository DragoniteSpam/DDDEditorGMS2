/// @description  void ui_render_input(Button, x, y);
/// @param Button
/// @param  x
/// @param  y

var x1=argument0.x+argument1;
var y1=argument0.y+argument2;
var x2=x1+argument0.width;
var y2=y1+argument0.height;

var tx=ui_get_text_x(argument0, x1, x2);
var ty=ui_get_text_y(argument0, y1, y2);

var value=argument0.value;

// this is not quite the same as ui_render_text
draw_set_halign(argument0.alignment);
draw_set_valign(argument0.valignment);
draw_set_color(argument0.color);
draw_text(tx, ty, string_hash_to_newline(argument0.text));

if (script_execute(argument0.validation, value)){
    var c=c_black;
    if (argument0.validation!=validate_string){
        var n=real(value);
        if (!is_clamped(n, argument0.value_lower, argument0.value_upper)){
            c=c_orange;
        }
    }
} else {
    var c=c_red;
}

var vx1=x1+argument0.value_x1;
var vy1=y1+argument0.value_y1;
var vx2=x1+argument0.value_x2;
var vy2=y1+argument0.value_y2;

var vtx=vx1+12;
var vty=mean(vy1, vy2);

if (!argument0.interactive){
    draw_rectangle_colour(vx1+1, vy1+1, vx2-1, vy2-1, c_ltgray, c_ltgray, c_ltgray, c_ltgray, false);
}
draw_rectangle(vx1, vy1, vx2, vy2, true);

draw_text_ext_colour(vtx, vty, string_hash_to_newline(value), -1, (vx2-vtx), c, c, c, c, 1);
if (string_length(value)==0){
    draw_text_ext_colour(vtx, vty, string_hash_to_newline(string(argument0.value_default)), -1, (vx2-2*vtx), c_dkgray, c_dkgray, c_dkgray, c_dkgray, 1);
}

if (argument0.interactive&&dialog_is_active(argument0.root)){
    if (ui_is_active(argument0)){
        // this will not work correctly if there are line breaks, but fixing that is
        // like the bottom of the priority queue right now
        if (current_second%2==0){
            var bx=tx+argument0.value_x1+string_width(string_hash_to_newline(value))+4;
            draw_line_width(bx, ty-7, bx, ty+7, 2);
        }
        var v0=value;
        value=value+keyboard_string;
        keyboard_string="";
        if (keyboard_check_pressed(vk_backspace)){
            value=string_backspace(value);
        }
        if (get_release_escape()){
            value="";
        }
        if (string_length(value)>argument0.value_limit){
            value=string_copy(value, 1, argument0.value_limit);
        }
        if (v0!=value){
            argument0.value=value;
            script_execute(argument0.onvaluechange, argument0);
        }
    }
    
    if (mouse_within_rectangle(vx1, vy1, vx2, vy2)){
        if (get_release_left()){
            ui_activate(argument0);
            keyboard_string="";
        } else if (Controller.press_help){
            //ds_stuff_help_auto(argument0);
        }
    } else {
        if (Controller.release_left){
            ui_activate(noone);
        }
    }
}
