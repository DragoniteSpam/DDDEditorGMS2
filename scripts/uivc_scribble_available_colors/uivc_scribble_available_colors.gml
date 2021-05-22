/// @param UIButton
function uivc_scribble_available_colors(argument0) {

    var button = argument0;
    var mode = Stuff.scribble;

    var dw = 320;
    var dh = 560;

    var dg = dialog_create(dw, dh, "Scribble Colors", dialog_default, dialog_destroy, button);

    var columns = 1;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;

    var xx = spacing;

    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;

    var b_width = 128;
    var b_height = 32;

    var yy = 64;
    var yy_base = yy;

    var el_list = create_list(xx, yy, "Scribble Colors", "<no colors>", ew, eh, 10, uivc_scribble_color_select, false, dg, mode.scribble_colours);
    el_list.tooltip = "All of the colors Scribble currently recognizes. Use them in text by typing the color name in square brackets, e.g. [c_blue]. Cancel color formatting by typing [/c].";
    el_list.entries_are = ListEntries.STRINGS;
    el_list.onmiddleclick = uivc_scribble_color_alphabetize;
    dg.el_list = el_list;

    yy += ui_get_list_height(el_list) + spacing;

    var el_add = create_button(xx, yy, "Add Color", ew, eh, fa_center, uivc_scribble_color_add, dg);
    el_add.tooltip = "Add a color for use in Scribble. You may have up to 255.";
    dg.el_add = el_add;

    yy += el_add.height + spacing;

    var el_remove = create_button(xx, yy, "Delete Color", ew, eh, fa_center, uivc_scribble_color_remove, dg);
    el_remove.tooltip = "Delete a color value. It will no longer be usable by Scribble.";
    dg.el_remove = el_remove;

    yy += el_remove.height + spacing;

    var el_name = create_input(xx, yy, "Name:", ew, eh, uivc_scribble_color_rename, "", "string", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    el_name.tooltip = "Add a name for this color. I would recommend prefixing all of your color names with \"c_\" to keep them organized, but you don't have to. Color names must be unique.";
    dg.el_name = el_name;

    yy += el_name.height + spacing;

    var el_value = create_color_picker(xx, yy, "Value:", ew, eh, uivc_scribble_color_value, c_black, vx1, vy1, vx2, vy2, dg);
    el_value.tooltip = "Select a color.";
    dg.el_value = el_value;

    yy += el_value.height + spacing;

    var el_done = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

    ds_list_add(dg.contents,
        el_list,
        el_add,
        el_remove,
        el_name,
        el_value,
        el_done
    );

    return dg;


}
