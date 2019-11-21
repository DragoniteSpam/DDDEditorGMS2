/// @param Dialog

var dialog = argument0;

var dw = 640;
var dh = 512;

var dg = dialog_create(dw, dh, "Open Project", dialog_default, dc_default, dialog);

var columns = 2;
var ew = (dw - 64) / columns;
var eh = 24;

var c2 = dw / columns;

var vx1 = 0;
var vy1 = 0;
var vx2 = ew;
var vy2 = vy1 + eh;

var b_width = 128;
var b_height = 32;

var yy = 64;
var yy_base = yy;
var spacing = 16;

var el_list = create_list(16, yy, "Recent Projects", "<no projects>", ew, eh, 10, null, false, dg, Stuff.all_projects[? "projects"]);
el_list.entries_are = ListEntries.STRINGS;
el_list.ondoubleclick = omu_project_load;
dg.el_list = el_list;

yy = yy + ui_get_list_height(el_list) + spacing;

var el_load = create_button(16, yy, "Load", ew, eh, fa_center, omu_project_load, dg);
el_load.tooltip = "Alternatively, double-click on the entry in the list.";
yy = yy + el_load.height + spacing;
var el_remove = create_button(16, yy, "Remove", ew, eh, fa_center, omu_project_remove, dg);
el_remove.tooltip = "Removes the project from this list. If you still have it saved on your computer it will not be deleted, but you will need to use Open Other if you want to edit it again.";
yy = yy + el_remove.height + spacing;
var el_other = create_button(16, yy, "Open Other", ew, eh, fa_center, omu_project_open, dg);
el_other.tooltip = "Open a .dddd game data file somehwere on your computer.";
yy = yy + el_other.height + spacing;

yy = yy_base;

var el_summary = create_text(c2 + 16, yy, "Summary", ew, eh, fa_left, ew, dg);
yy = yy + el_summary.height + spacing;

var el_summary_todo = create_text(c2 + 16, yy + 4 * spacing, "maybe some day i'll fill in stuff like file size and date modified and stuff idk", ew, eh, fa_left, ew, dg);
yy = yy + el_summary_todo.height + spacing;

var el_never_mind = create_button(dw /2 - b_width / 2, dh - 32 - b_height / 2, "Create New", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_list,
    el_load, el_remove, el_other,
    el_summary, el_summary_todo,
    el_never_mind
);

return dg;