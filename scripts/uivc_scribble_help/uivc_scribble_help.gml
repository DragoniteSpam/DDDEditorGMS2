/// @param UIButton
function uivc_scribble_help(argument0) {

    var button = argument0;
    var mode = Stuff.scribble;

    var dw = 1280;
    var dh = 760;

    var dg = dialog_create(dw, dh, "Scribble Cheat Sheet", dialog_default, dc_default, button);

    var columns = 1;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;

    var xx = spacing;
    var xx_desc = dw / 4;

    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;

    var b_width = 128;
    var b_height = 32;

    var yy = 64;
    var yy_base = yy;

    var el_text_1 = create_text(xx, yy - spacing, "[FDefault20]Welcome to [wave][rainbow]Scribble[/rainbow][/wave]!", ew, eh, fa_left, ew, dg);
    yy += el_text_1.height + spacing;

    var el_text_2 = create_text(xx, yy, "[wave][rainbow]Scribble[] is a vertex buffer-based text renderer for Game Maker Studio 2 by Juju Adams. It has the advantages of both being faster than the default Game Maker text renderer and allowing for on-the-fly text effects like color, font, [spr_camera_icons,2]inline images and some [pulse][c_blue]special effects[], which means you can do some cool things with it.", ew, eh, fa_left, ew, dg);
    yy += el_text_2.height + spacing * 3;

    var el_text_3 = create_text(xx, yy, "You use command tags to control effects, not unlike HTML or BBCode. Here are a list of the commands you can use ([wave][rainbow]Scribble[] includes a few other which are not currenty supported by this tool). If you want to draw a square bracket itself, you can escape commands by repeating the open-bracket character.", ew, eh, fa_left, ew, dg);
    yy += el_text_3.height + spacing * 3;

    var line_spacing = 20;
    var line_offset_scribble = -8;
    var el_text_reset = create_text(xx, yy, "[]", ew, eh, fa_left, ew, dg);
    var el_text_sample_reset = create_text(xx_desc, yy + line_offset_scribble, "Reset formatting to defaults", ew, eh, fa_left, ew, dg);
    yy += line_spacing;
    var el_text_colour = create_text(xx, yy, "[<name of colour>]", ew, eh, fa_left, ew, dg);
    var el_text_sample_colour = create_text(xx_desc, yy + line_offset_scribble, "Set [#0000ff]colour[]", ew, eh, fa_left, ew, dg);
    yy += line_spacing;
    var el_text_colour_hex = create_text(xx, yy, "[#<hex code>]", ew, eh, fa_left, ew, dg);
    var el_text_sample_colour_hex = create_text(xx_desc, yy + line_offset_scribble, "Set [c_blue]colour[] via hex code, using the industry standard 24-bit RGB format (#RRGGBB)", ew, eh, fa_left, ew, dg);
    yy += line_spacing;
    var el_text_colour_reset = create_text(xx, yy, "[/colour] [/c]", ew, eh, fa_left, ew, dg);
    var el_text_sample_colour_reset = create_text(xx_desc, yy + line_offset_scribble, "Reset colour to default", ew, eh, fa_left, ew, dg);
    yy += line_spacing;
    var el_text_font = create_text(xx, yy, "[<name of font>] [/font] [/f]", ew, eh, fa_left, ew, dg);
    var el_text_sample_font = create_text(xx_desc, yy + line_offset_scribble, "[FComicSans]Set font / reset font", ew, eh, fa_left, ew, dg);
    yy += line_spacing;
    var el_text_img = create_text(xx, yy, "[<name of sprite>]", ew, eh, fa_left, ew, dg);
    var el_text_sample_img = create_text(xx_desc, yy + line_offset_scribble, "Insert an [spr_event_info_scribble] animated sprite, starting on index 0 (this is not currently super useful in this preview tool)", ew, eh, fa_left, ew, dg);
    yy += line_spacing;
    var el_text_img_static = create_text(xx, yy, "[<name of sprite>,<image>]", ew, eh, fa_left, ew, dg);
    var el_text_sample_img_static = create_text(xx_desc, yy + line_offset_scribble, "Insert a [spr_event_info_scribble,0] static sprite, using the sepcified image index", ew, eh, fa_left, ew, dg);
    yy += line_spacing;
    var el_text_img_animated = create_text(xx, yy, "[<name of sprite>,<image>,<speed>]", ew, eh, fa_left, ew, dg);
    var el_text_sample_img_animated = create_text(xx_desc, yy + line_offset_scribble, "Insert an [spr_event_info_scribble,0,0.05] animated sprite, using the sepcified image index and animation speed", ew, eh, fa_left, ew, dg);
    yy += line_spacing;
    var el_text_align_left = create_text(xx, yy, "[fa_left]", ew, eh, fa_left, ew, dg);
    var el_text_sample_align_left = create_text(xx_desc, yy, "Align horizontally to the left. This will insert a line break if used in the middle of a line of text", ew - xx_desc, eh, fa_left, ew, dg);
    yy += line_spacing;
    var el_text_align_right = create_text(xx, yy, "[fa_right]", ew, eh, fa_left, ew, dg);
    var el_text_sample_align_right = create_text(xx_desc, yy, "Align horizontally to the right. This will insert a line break if used in the middle of a line of text", ew - xx_desc, eh, fa_right, ew, dg);
    yy += line_spacing;
    var el_text_align_center = create_text(xx, yy, "[fa_center] [fa_centre]", ew, eh, fa_left, ew, dg);
    var el_text_sample_align_center = create_text(xx_desc, yy, "Align centrally. This will insert a line break if used in the middle of a line of text", ew - xx_desc, eh, fa_center, ew, dg);
    yy += line_spacing;
    var el_text_scale = create_text(xx, yy, "[scale,<factor>] [/scale] [/s]", ew, eh, fa_left, ew, dg);
    var el_text_sample_scale = create_text(xx_desc, yy + line_offset_scribble, "[scale,0.75]Scale text (I don't recommend this, due to how bitmap fonts work)", ew, eh, fa_left, ew, dg);
    yy += line_spacing;
    var el_text_slant = create_text(xx, yy, "[slant] [/slant]", ew, eh, fa_left, ew, dg);
    var el_text_sample_slant = create_text(xx_desc, yy + line_offset_scribble, "[slant]Set/unset italic emulation (note: this may anger fontographers)", ew, eh, fa_left, ew, dg);
    yy += line_spacing * 3;
    var el_text_special = create_text(xx, yy, "Special Effects", ew, eh, fa_left, ew, dg);
    el_text_special.color = c_blue;
    yy += line_spacing;
    var el_text_wave = create_text(xx, yy, "[wave]    [/wave]", ew, eh, fa_left, ew, dg);
    var el_text_sample_wave = create_text(xx_desc, yy + line_offset_scribble, "[wave]Set/unset text to wave up and down", ew, eh, fa_left, ew, dg);
    yy += line_spacing;
    var el_text_shake = create_text(xx, yy, "[shake]   [/shake]", ew, eh, fa_left, ew, dg);
    var el_text_sample_shake = create_text(xx_desc, yy + line_offset_scribble, "[shake]Set/unset text to shake", ew, eh, fa_left, ew, dg);
    yy += line_spacing;
    var el_text_rainbow = create_text(xx, yy, "[wobble]  [/wobble]", ew, eh, fa_left, ew, dg);
    var el_text_sample_rainbow = create_text(xx_desc, yy + line_offset_scribble, "[rainbow]Set/unset text to cycle through rainbow colours", ew, eh, fa_left, ew, dg);
    yy += line_spacing;
    var el_text_wobble = create_text(xx, yy, "[wobble]  [/wobble]", ew, eh, fa_left, ew, dg);
    var el_text_sample_wobble = create_text(xx_desc, yy + line_offset_scribble, "[wobble]Set/unset text to wobble by rotating back and forth", ew, eh, fa_left, ew, dg);
    yy += line_spacing;
    var el_text_pulse = create_text(xx, yy, "[pulse]   [/pulse]", ew, eh, fa_left, ew, dg);
    var el_text_sample_pulse = create_text(xx_desc, yy + line_offset_scribble, "[pulse]Set/unset text to shrink and grow rhythmically", ew, eh, fa_left, ew, dg);
    yy += line_spacing;

    var el_github = create_button(dw / 3 - b_width / 2, dh - 32 - b_height / 2, "View on Github", b_width, b_height, fa_center, uivc_scribble_github, dg);
    var el_done = create_button(dw * 2 / 3 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

    ds_list_add(dg.contents,
        el_text_1,
        el_text_2,
        el_text_3,
        // tags
        el_text_reset,
        el_text_colour,
        el_text_colour_hex,
        el_text_colour_reset,
        el_text_font,
        el_text_img,
        el_text_img_static,
        el_text_img_animated,
        el_text_align_left,
        el_text_align_right,
        el_text_align_center,
        el_text_scale,
        el_text_slant,
        // effects
        el_text_special,
        el_text_wave,
        el_text_shake,
        el_text_rainbow,
        el_text_wobble,
        el_text_pulse,
        // samples
        el_text_sample_reset,
        el_text_sample_colour,
        el_text_sample_colour_hex,
        el_text_sample_colour_reset,
        el_text_sample_font,
        el_text_sample_img,
        el_text_sample_img_static,
        el_text_sample_img_animated,
        el_text_sample_align_left,
        el_text_sample_align_right,
        el_text_sample_align_center,
        el_text_sample_scale,
        el_text_sample_slant,
        // effects
        el_text_sample_wave,
        el_text_sample_shake,
        el_text_sample_rainbow,
        el_text_sample_wobble,
        el_text_sample_pulse,
        // the rest
        el_github,
        el_done
    );

    return dg;


}
