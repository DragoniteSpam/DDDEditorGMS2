/// @description void ui_render_bitfield_option_picture(UIBitFieldOption, x, y);
/// @param UIBitFieldOption
/// @param x
/// @param y

// default button and interactivity
ui_render_bitfield_option(argument0, argument1, argument2);

var x1=argument0.x+argument1;
var y1=argument0.y+argument2;
var x2=x1+argument0.width;
var y2=y1+argument0.height;

draw_sprite(argument0.sprite_index, argument0.image_index, mean(x1, x2), mean(y1, y2));
