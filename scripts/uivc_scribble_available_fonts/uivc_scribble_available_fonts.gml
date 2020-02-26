/// @param UIButton

var button = argument0;
var mode = Stuff.scribble;

var dw = 320;
var dh = 560;

var dg = dialog_create(dw, dh, "Scribble Fonts", dialog_default, dc_default, button);

var spacing = 16;
var columns = 1;
var ew = (dw - spacing * columns * 2) / columns;
var eh = 24;

var xx = spacing;

var vx1 = ew / 2;
var vy1 = 0;
var vx2 = ew;
var vy2 = vy1 + eh;

var b_width = 128;
var b_height = 32;

var yy = 64;
var yy_base = yy;

var el_list = create_list(xx, yy, "Scribble Fonts", "<no fonts>", ew, eh, 16, null, false, dg, mode.scribble_fonts);
el_list.tooltip = "All of the fonts Scribble currently recognizes. Use them in text by typing the font name in square brackets, e.g. [FCalibriBold]. Reset to the default font by typing [/f].";
el_list.entries_are = ListEntries.STRINGS;
dg.el_list = el_list;

var el_done = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_list,
    el_done
);

return dg;