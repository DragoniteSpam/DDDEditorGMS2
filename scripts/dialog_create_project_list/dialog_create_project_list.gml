function dialog_create_project_list(root) {
    var dw = 640;
    var dh = 512;
    
    var dg = dialog_create(dw, dh, "Open Project", dialog_default, dialog_destroy, root);
    dg.flags |= DialogFlags.NO_CLOSE_BUTTON;
    
    var columns = 2;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;
    
    var c2 = dw / columns;
    
    var vx1 = 0;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;
    
    var b_width = 128;
    var b_height = 32;
    
    var yy = 64;
    var yy_base = yy;
    var project_list = Stuff.all_projects[$ "projects"];
    
    var f_project_load = function(button) {
        var selected_project = ui_list_selection(button.root.el_list);
        if (selected_project + 1) {
            var name = button.root.el_list.entries[| selected_project];
            var path_new = PATH_PROJECTS + name + "\\" + name + ".dddd";
            if (serialize_load_base(path_new, name)) {
                dialog_destroy();
            } // else the files could not be loaded
            // un-register the mouse
            Controller.mouse_left = false;
            Controller.press_left = false;
            Controller.release_left = false;
            Controller.double_left = false;
            Controller.time_left = -1;
            Controller.last_time_left = -1;
            Controller.ignore_next = 1;
        }
    };
    
    var el_list = create_list(16, yy, "Recent Projects", "<no projects>", ew, eh, 10, function(list) {
        var selection = ui_list_selection(list);
        if (selection + 1) {
            var version_str = list.root.versions[selection];
            var date_str = list.root.timestamp_dates[selection];
            var time_str = list.root.timestamp_times[selection];
            var file_count = list.root.file_counts[selection];
            list.root.el_summary_name.text = "Name: " + list.root.names[selection];
            list.root.el_summary_version.text = "File version: " + ((string_length(version_str) > 0) ? (version_str + " (0x" + string_hex(real(version_str)) + ")") : "N/A");
            list.root.el_summary_summary.text = "Summary: " + list.root.strings[selection];
            list.root.el_summary_author.text = "Author: " + list.root.authors[selection];
            list.root.el_summary_timestamp_date.text = "Date Modified: " + ((string_length(date_str) > 0) ? date_str : "N/A");
            list.root.el_summary_timestamp_time.text = "Time Modified: " + ((string_length(time_str) > 0) ? time_str : "N/A");
            list.root.el_summary_file_count.text = "Asset files: " + ((file_count > 0) ? string(file_count) : "N/A");
        } else {
            list.root.el_summary_name.text = "";
            list.root.el_summary_version.text = "";
            list.root.el_summary_summary.text = "";
            list.root.el_summary_author.text = "";
            list.root.el_summary_timestamp_date.text = "";
            list.root.el_summary_timestamp_time.text = "";
            list.root.el_summary_file_count.text = "";
        }
    }, false, dg);
    for (var i = 0, n = array_length(project_list); i < n; i++) {
        ds_list_add(el_list.entries, project_list[i]);
    }
    el_list.tooltip = "Here's a list of projects you've worked on recently.";
    el_list.entries_are = ListEntries.STRINGS;
    el_list.ondoubleclick = f_project_load;
    dg.el_list = el_list;
    
    #region metadata
    var n_projects = array_length(project_list);
    dg.names = array_create(n_projects);
    dg.strings = array_create(n_projects);
    dg.authors = array_create(n_projects);
    dg.versions = array_create(n_projects);
    dg.timestamp_dates = array_create(n_projects);
    dg.timestamp_times = array_create(n_projects);
    dg.file_counts = array_create(n_projects);
    
    var fbuffer = buffer_create(1600, buffer_fixed, 1);
    for (var i = 0; i < n_projects; i++) {
        dg.names[i] = project_list[i];
        dg.strings[i] = "";
        dg.authors[i] = "";
        dg.versions[i] = "";
        dg.timestamp_dates[i] = "";
        dg.timestamp_times[i] = "";
        dg.file_counts[i] = 0;
        var path_new = PATH_PROJECTS + project_list[i] + "\\" + project_list[i] + ".dddd";
        try {
            buffer_load_partial(fbuffer, path_new, 0, 1600, 0);
            buffer_seek(fbuffer, buffer_seek_start, 0);
            var header = chr(buffer_read(fbuffer, buffer_u8)) + chr(buffer_read(fbuffer, buffer_u8)) + chr(buffer_read(fbuffer, buffer_u8));
            if (header == "DDD") {
                var version = buffer_read(fbuffer, buffer_u32);
                dg.versions[i] = string(version);
                dg.strings[i] = buffer_read(fbuffer, buffer_string);
                dg.authors [i] = buffer_read(fbuffer, buffer_string);
                dg.timestamp_dates[i] = string(buffer_read(fbuffer, buffer_u16)) + " / " + string(buffer_read(fbuffer, buffer_u8)) + " / " +
                    string(buffer_read(fbuffer, buffer_u8));
                dg.timestamp_times[i] = string(buffer_read(fbuffer, buffer_u8)) + ":" + string_pad(buffer_read(fbuffer, buffer_u8), "0", 2) + ":" +
                    string_pad(buffer_read(fbuffer, buffer_u8), "0", 2);
                dg.file_counts[i] = buffer_read(fbuffer, buffer_u8);
            }
        } catch (e) {
            dg.names[i] = "invalid project";
            dg.strings[i] = "";
            dg.authors[i] = "";
            dg.versions[i] = "";
            dg.timestamp_dates[i] = "";
            dg.timestamp_times[i] = "";
            dg.file_counts[i] = 0;
        }
    }
    buffer_delete(fbuffer);
    #endregion
    
    yy += ui_get_list_height(el_list) + spacing;
    
    var el_load = create_button(16, yy, "Load", ew, eh, fa_center, f_project_load, dg);
    el_load.tooltip = "Alternatively, double-click on the entry in the list.";
    yy += el_load.height + spacing;
    var el_remove = create_button(16, yy, "Delete", ew, eh, fa_center, function(button) {
        var selected_project = ui_list_selection(button.root.el_list);
        if (selected_project + 1) {
            var project = button.root.el_list.entries[| selected_project];
            var dialog = emu_dialog_confirm(button, "Do you want to remove " + project + "? Its autosave files will be deleted, but any files you saved elsewhere on your computer will still be there and you will be able to re-load them later.", function() {
                var project = self.root.project;
                var list = Stuff.all_projects[$ "projects"];
                var name = list[| project];
                ds_list_delete(list, project);
                ui_list_deselect(self.root.root.root.el_list);
                directory_destroy(PATH_PROJECTS + name);
                var buffer = buffer_create(32, buffer_grow, 1);
                buffer_write(buffer, buffer_text, json_stringify(Stuff.all_projects));
                buffer_save_ext(buffer, "projects.json", 0, buffer_tell(buffer));
                buffer_delete(buffer);
                self.root.Dispose();
            });
            dialog.project = selected_project;
        }
    }, dg);
    el_remove.tooltip = "Deletes the project from this list. If you still have it saved on your computer it will not be deleted, but you will need to use Open Other if you want to edit it again.";
    yy += el_remove.height + spacing;
    var el_other = create_button(16, yy, "Open Other", ew, eh, fa_center, function(button) {
        var fn = get_open_filename_ddd();
        if (file_exists(fn)) {
            if (serialize_load_base(fn, filename_name(filename_change_ext(fn, "")))) {
                dialog_destroy();
            } // else the files could not be loaded
            // un-register the mouse
            Controller.mouse_left = false;
            Controller.press_left = false;
            Controller.release_left = false;
            Controller.double_left = false;
            Controller.time_left = -1;
            Controller.last_time_left = -1;
            Controller.ignore_next = 1;
        }
    }, dg);
    el_other.tooltip = "Open a .dddd game data file somehwere on your computer. The original will not be modified until you save over it; a copy will be saved to the editor's local storage.";
    yy += el_other.height + spacing;
    
    yy = yy_base;
    
    var el_summary = create_text(c2 + 16, yy, "Summary", ew, eh, fa_left, ew, dg);
    el_summary.color = c_blue;
    yy += el_summary.height + spacing;
    
    var el_summary_name = create_text(c2 + 16, yy, "", ew, eh, fa_left, ew, dg);
    dg.el_summary_name = el_summary_name;
    yy += el_summary_name.height + spacing;
    
    var el_summary_version = create_text(c2 + 16, yy, "", ew, eh, fa_left, ew, dg);
    dg.el_summary_version = el_summary_version;
    yy += el_summary_version.height + spacing;
    
    var el_summary_timestamp_date = create_text(c2 + 16, yy, "", ew, eh, fa_left, ew, dg);
    dg.el_summary_timestamp_date = el_summary_timestamp_date;
    yy += el_summary_timestamp_date.height + spacing;
    
    var el_summary_timestamp_time = create_text(c2 + 16, yy, "", ew, eh, fa_left, ew, dg);
    dg.el_summary_timestamp_time = el_summary_timestamp_time;
    yy += el_summary_timestamp_time.height + spacing;
    
    var el_summary_author = create_text(c2 + 16, yy, "", ew, eh, fa_left, ew, dg);
    dg.el_summary_author = el_summary_author;
    yy += el_summary_author.height + spacing;
    
    var el_summary_file_count = create_text(c2 + 16, yy, "", ew, eh, fa_left, ew, dg);
    dg.el_summary_file_count = el_summary_file_count;
    yy += el_summary_file_count.height + spacing;
    
    var el_summary_summary = create_text(c2 + 16, yy - 8, "", ew, eh, fa_left, ew, dg);
    el_summary_summary.valignment = fa_top;
    dg.el_summary_summary = el_summary_summary;
    yy += el_summary_summary.height + spacing - 8;
    
    var el_new = create_button(dw /2 - b_width / 2, dh - 32 - b_height / 2, "Create New", b_width, b_height, fa_center, dmu_dialog_commit, dg);
    el_new.tooltip = "New maps will be created with a default white directional light with a vector of (-1, -1, -1).";
    
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
        el_new
    );
    
    return dg;
}