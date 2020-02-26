/// @param UIButton

var button = argument0;
var mode = Stuff.scribble;

var dw = 1280;
var dh = 800;

var dg = dialog_create(dw, dh, "Scribble Cheat Sheet", dialog_default, dc_default, button);

var spacing = 16;
var columns = 1;
var ew = (dw - spacing * columns * 4) / columns;
var eh = 24;

var xx = spacing;
var xx_desc = dw / 4;

var vx1 = ew / 2;
var vy1 = 0;
var vx2 = ew;
var vy2 = vy1 + eh;

var b_width = 128;
var b_height = 32;

var yy = 64;
var yy_base = yy;

var el_text_1 = create_text(xx, yy, "Welcome to Scribble!", ew, eh, fa_left, ew, dg);
el_text_1.valignment = fa_top;

yy = yy + el_text_1.height + spacing;

var el_text_2 = create_text(xx, yy, "Scribble is a vertex buffer-based text renderer for Game Maker Studio 2 by Juju Adams. It has the advantages of both being faster than the default Game Maker text renderer and allowing for on-the-fly text effects like color, font, inline images and some special effects, which means you can do some cool things with it.", ew, eh, fa_left, ew, dg);
el_text_2.valignment = fa_top;

yy = yy + el_text_2.height + spacing * 3;

var el_text_3 = create_text(xx, yy, "You use command tags to control effects, not unlike HTML or BBCode. Here are a list of the commands you can use (Scribble includes a few other which are not currenty supported by this tool):", ew, eh, fa_left, ew, dg);
el_text_3.valignment = fa_top;

yy = yy + el_text_3.height + spacing * 2;

var el_text_4 = create_text(xx, yy,
@"[]
[<name of colour>]
[#<hex code>]
[/colour] [/c]
[<name of font>] [/font] [/f]
[<name of sprite>]
[<name of sprite>,<image>]
[<name of sprite>,<image>,<speed>]
[fa_left]
[fa_right]
[fa_center] [fa_centre]
[scale,<factor>] [/scale] [/s]
[slant] [/slant]

Special effects:
[wave]    [/wave]
[shake]   [/shake]
[rainbow] [/rainbow]
[wobble]  [/wobble]
[pulse]   [/pulse]"
, ew, eh, fa_left, ew, dg);
el_text_4.valignment = fa_top;

var el_text_5 = create_text(xx_desc, yy,
@"Reset formatting to defaults
Set colour
Set colour via a hexcode, using the industry standard 24-bit RGB format (#RRGGBB)
Reset colour to the default
Set font / Reset font
Insert an animated sprite starting on image 0 (note: this is not currently super useful in this preview tool)
Insert a static sprite using the specified image index
Insert animated sprite using the specified image index and animation speed
Align horizontally to the left. This will insert a line break if used in the middle of a line of text
Align horizontally to the right. This will insert a line break if used in the middle of a line of text
Align centrally. This will insert a line break if used in the middle of a line of text
Scale text
Set/unset italic emulation


Set/unset text to wave up and down
Set/unset text to shake
Set/unset text to cycle through rainbow colours
Set/unset text to wobble by rotating back and forth
Set/unset text to shrink and grow rhythmically"
, ew, eh, fa_left, ew, dg);
el_text_5.valignment = fa_top;

var el_github = create_button(dw / 3 - b_width / 2, dh - 32 - b_height / 2, "View on Github", b_width, b_height, fa_center, uivc_scribble_github, dg);
var el_done = create_button(dw * 2 / 3 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_text_1,
    el_text_2,
    el_text_3,
    el_text_4,
    el_text_5,
    el_github,
    el_done
);

return dg;