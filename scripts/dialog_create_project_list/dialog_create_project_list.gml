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
var project_list = Stuff.all_projects[? "projects"]

var el_list = create_list(16, yy, "Recent Projects", "<no projects>", ew, eh, 10, uivc_list_selection_project_list, false, dg, project_list);
el_list.entries_are = ListEntries.STRINGS;
el_list.ondoubleclick = omu_project_load;
dg.el_list = el_list;

var n_projects = ds_list_size(project_list);
dg.names = array_create(n_projects);
dg.strings = array_create(n_projects);
dg.authors = array_create(n_projects);
dg.versions = array_create(n_projects);
dg.timestamp_dates = array_create(n_projects);
dg.timestamp_times = array_create(n_projects);
dg.file_counts = array_create(n_projects);

var fbuffer = buffer_create(512, buffer_fixed, 1);
for (var i = 0; i < n_projects; i++) {
    dg.names[i] = project_list[| i];
    dg.strings[i] = "";
    dg.authors[i] = "";
    dg.versions[i] = "";
    dg.timestamp_dates[i] = "";
    dg.timestamp_times[i] = "";
    dg.file_counts[i] = 0;
    var path_new = PATH_PROJECTS + project_list[| i] + "\\" + project_list[| i] + ".dddd";
    // @todo gml update try catch
    if (file_exists(path_new)) {
        // magic numbers abound
        buffer_load_partial(fbuffer, path_new, 0, 512, 0);
        var header = chr(buffer_read(fbuffer, buffer_u8)) + chr(buffer_read(fbuffer, buffer_u8)) + chr(buffer_read(fbuffer, buffer_u8));
        if (buffer_peek(fbuffer, 0, buffer_u8) == $44 && buffer_peek(fbuffer, 1, buffer_u8) == $44 && buffer_peek(fbuffer, 2, buffer_u8) == $44) {
            var version = buffer_peek(fbuffer, 3, buffer_u32);;
            dg.versions[i] = string(version);
            if (version >= DataVersions.DATA_MODULARITY) {
                buffer_seek(fbuffer, buffer_seek_start, 8);
                dg.strings[i] = buffer_read(fbuffer, buffer_string);
                dg.authors [i] = buffer_read(fbuffer, buffer_string);
                dg.timestamp_dates[i] = string(buffer_read(fbuffer, buffer_u16)) + " / " + string(buffer_read(fbuffer, buffer_u8)) + " / " +
                    string(buffer_read(fbuffer, buffer_u8));
                dg.timestamp_times[i] = string(buffer_read(fbuffer, buffer_u8)) + ":" + string_pad(buffer_read(fbuffer, buffer_u8), "0", 2) + ":" +
                    string_pad(buffer_read(fbuffer, buffer_u8), "0", 2);
                dg.file_counts[i] = buffer_read(fbuffer, buffer_u8);
            }
        }
    }
}
buffer_delete(fbuffer);

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
el_summary.color = c_blue;
yy = yy + el_summary.height + spacing;

var el_summary_name = create_text(c2 + 16, yy, "", ew, eh, fa_left, ew, dg);
dg.el_summary_name = el_summary_name;
yy = yy + el_summary_name.height + spacing;

var el_summary_version = create_text(c2 + 16, yy, "", ew, eh, fa_left, ew, dg);
dg.el_summary_version = el_summary_version;
yy = yy + el_summary_version.height + spacing;

var el_summary_timestamp_date = create_text(c2 + 16, yy, "", ew, eh, fa_left, ew, dg);
dg.el_summary_timestamp_date = el_summary_timestamp_date;
yy = yy + el_summary_timestamp_date.height + spacing;

var el_summary_timestamp_time = create_text(c2 + 16, yy, "", ew, eh, fa_left, ew, dg);
dg.el_summary_timestamp_time = el_summary_timestamp_time;
yy = yy + el_summary_timestamp_time.height + spacing;

var el_summary_author = create_text(c2 + 16, yy, "", ew, eh, fa_left, ew, dg);
dg.el_summary_author = el_summary_author;
yy = yy + el_summary_author.height + spacing;

var el_summary_file_count = create_text(c2 + 16, yy, "", ew, eh, fa_left, ew, dg);
dg.el_summary_file_count = el_summary_file_count;
yy = yy + el_summary_file_count.height + spacing;

var el_summary_summary = create_text(c2 + 16, yy - 8, "", ew, eh, fa_left, ew, dg);
el_summary_summary.valignment = fa_top;
dg.el_summary_summary = el_summary_summary;
yy = yy + el_summary_summary.height + spacing - 8;

var el_never_mind = create_button(dw /2 - b_width / 2, dh - 32 - b_height / 2, "Create New", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_list,
    el_load,
    el_remove,
    el_other,
    el_summary,
    el_summary_name,
    el_summary_version,
    el_summary_summary,
    el_summary_author,
    el_summary_timestamp_date,
    el_summary_timestamp_time,
    el_summary_file_count,
    el_never_mind
);

return dg;