/// @description  void ui_render_checkbox(UIButton, x, y);
/// @param UIButton
/// @param  x
/// @param  y

var x1=argument0.x+argument1;
var y1=argument0.y+argument2;
var x2=x1+argument0.width;
var y2=y1+argument0.height;

var tx=ui_get_text_x(argument0, x1, x2);
var ty=ui_get_text_y(argument0, y1, y2);

draw_set_halign(argument0.alignment);
draw_set_valign(argument0.valignment);
draw_set_color(argument0.color);
draw_text(tx+32, ty, string_hash_to_newline(argument0.text));

var s2=8;

if (!argument0.interactive){
    draw_rectangle_colour(tx+16-s2, ty-s2, tx+16+s2, ty+s2, c_ltgray, c_ltgray, c_ltgray, c_ltgray, false);
} else {
    if (dialog_is_active(argument0.root)){
        if (mouse_within_rectangle(x1, y1, x2, y2)){
            draw_rectangle_colour(tx+16-s2, ty-s2, tx+16+s2, ty+s2, c_ltgray, c_ltgray, c_ltgray, c_ltgray, false);
        }
    }
}
draw_rectangle(tx+16-s2, ty-s2, tx+16+s2, ty+s2, true);

if (argument0.interactive){
    var a=1;
} else {
    var a=0.5;
}

// these are actually not binary states - in some rare cases there may be an "undecided," etc state
if (argument0.value==2){
    draw_sprite_ext(spr_check, 1, tx+16, ty, 1, 1, 0, c_white, a);
} else if (argument0.value){
    draw_sprite_ext(spr_check, 0, tx+16, ty, 1, 1, 0, c_white, a);
}

if (argument0.interactive&&dialog_is_active(argument0.root)){
    if (mouse_within_rectangle(x1, y1, x2, y2)){
        if (get_release_left()){
            argument0.value=!argument0.value;
            script_execute(argument0.onvaluechange, argument0);
        } else if (Controller.press_help){
            //ds_stuff_help_auto(argument0);
        }
    }
}
