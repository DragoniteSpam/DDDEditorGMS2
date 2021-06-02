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
    var project_list = Stuff.all_projects.projects;
    
    var f_project_load = function(button) {
        var selected_project = ui_list_selection(button.root.el_list);
        if (selected_project + 1) {
            var name = button.root.el_list.entries[| selected_project];
            var path_new = PATH_PROJECTS + name + "/" + name + ".dddd";
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
            var version = list.root.versions[selection];
            var date_str = list.root.timestamp_dates[selection];
            var time_str = list.root.timestamp_times[selection];
            list.root.el_summary_name.text = "Name: " + list.root.names[selection];
            list.root.el_summary_summary.text = "Summary: " + list.root.strings[selection];
            list.root.el_summary_author.text = "Author: " + list.root.authors[selection];
            list.root.el_summary_timestamp_date.text = "Date Modified: " + ((string_length(date_str) > 0) ? date_str : "N/A");
            list.root.el_summary_timestamp_time.text = "Time Modified: " + ((string_length(time_str) > 0) ? time_str : "N/A");
            if (version > 0) {
                var out_of_date = (version < LAST_SAFE_VERSION) ? "[c_red]" : "";
                list.root.el_summary_summary.text += out_of_date + "\n\n(Legacy file version: " + string(version) + " (0x" + string_hex(version) + "))";
            }
        } else {
            list.root.el_summary_name.text = "";
            list.root.el_summary_summary.text = "";
            list.root.el_summary_author.text = "";
            list.root.el_summary_timestamp_date.text = "";
            list.root.el_summary_timestamp_time.text = "";
        }
    }, false, dg);
    for (var i = 0, n = array_length(project_list); i < n; i++) {
        if (is_string(project_list[i])) {
            project_list[@ i] = { name: project_list[i], legacy: true, id: "", };
        }
        ds_list_add(el_list.entries, project_list[i].name);
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
    
    for (var i = 0; i < n_projects; i++) {
        var project = project_list[i];
        dg.names[i] = project.name;
        dg.strings[i] = "";
        dg.authors[i] = "";
        dg.versions[i] = 0;
        dg.timestamp_dates[i] = "";
        dg.timestamp_times[i] = "";
        try {
            if (project.legacy) {
                var path_new = PATH_PROJECTS + project.name + "/" + project.name + ".dddd";
                var fbuffer = buffer_create(1600, buffer_fixed, 1);
                buffer_load_partial(fbuffer, path_new, 0, 1600, 0);
                buffer_seek(fbuffer, buffer_seek_start, 0);
                var header = chr(buffer_read(fbuffer, buffer_u8)) + chr(buffer_read(fbuffer, buffer_u8)) + chr(buffer_read(fbuffer, buffer_u8));
                if (header == "DDD") {
                    dg.versions[i] = buffer_read(fbuffer, buffer_u32);
                    dg.strings[i] = buffer_read(fbuffer, buffer_string);
                    dg.authors [i] = buffer_read(fbuffer, buffer_string);
                    dg.timestamp_dates[i] = string(buffer_read(fbuffer, buffer_u16)) + " / " + string(buffer_read(fbuffer, buffer_u8)) + " / " +
                        string(buffer_read(fbuffer, buffer_u8));
                    dg.timestamp_times[i] = string(buffer_read(fbuffer, buffer_u8)) + ":" + string_pad(buffer_read(fbuffer, buffer_u8), "0", 2) + ":" +
                        string_pad(buffer_read(fbuffer, buffer_u8), "0", 2);
                }
                buffer_delete(fbuffer);
            } else {
                var path_new = PATH_PROJECTS + project.id + "/project" + EXPORT_EXTENSION_PROJECT;
                var yaml = snap_from_yaml(path_new);
                dg.names[i] = project.name;
                dg.strings[i] = yaml.summary;
                dg.authors[i] = yaml.author;
                dg.versions[i] = 0;
                dg.timestamp_dates[i] = string(yaml.date.year) + "-" + string(yaml.date.month) + "-" + string(yaml.date.day);
                dg.timestamp_times[i] = string(yaml.date.hour) + ":" + string_pad(yaml.date.minute, "0", 2) + ":" + string_pad(yaml.date.second, "0", 2);
            }
        } catch (e) {
            dg.names[i] = "invalid project";
            dg.strings[i] = "";
            dg.authors[i] = "";
            dg.versions[i] = 0;
            dg.timestamp_dates[i] = "";
            dg.timestamp_times[i] = "";
        }
    }
    #endregion
    
    yy += ui_get_list_height(el_list) + spacing;
    
    var el_load = create_button(16, yy, "Load", ew, eh, fa_center, f_project_load, dg);
    el_load.tooltip = "Alternatively, double-click on the entry in the list.";
    yy += el_load.height + spacing;
    var el_remove = create_button(16, yy, "Delete", ew, eh, fa_center, function(button) {
        var selected_project = ui_list_selection(button.root.el_list);
        if (selected_project + 1) {
            var project = Stuff.all_projects.projects[selected_project];
            var dialog = emu_dialog_confirm(button, "Do you want to remove " + project.name + "? Its autosave files will be deleted, but any files you saved elsewhere on your computer will still be there and you will be able to re-load them later.", function() {
                var project = Stuff.all_projects.projects[self.root.project];
                array_delete(Stuff.all_projects.projects, self.root.project, 1);
                ui_list_deselect(self.root.root.root.el_list);
                ds_list_delete(self.root.root.root.el_list.entries, self.root.project);
                directory_destroy(PATH_PROJECTS + project.name);
                buffer_write_file(json_stringify(Stuff.all_projects), "projects.json");
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
    
    var el_summary_timestamp_date = create_text(c2 + 16, yy, "", ew, eh, fa_left, ew, dg);
    dg.el_summary_timestamp_date = el_summary_timestamp_date;
    yy += el_summary_timestamp_date.height + spacing;
    
    var el_summary_timestamp_time = create_text(c2 + 16, yy, "", ew, eh, fa_left, ew, dg);
    dg.el_summary_timestamp_time = el_summary_timestamp_time;
    yy += el_summary_timestamp_time.height + spacing;
    
    var el_summary_author = create_text(c2 + 16, yy, "", ew, eh, fa_left, ew, dg);
    dg.el_summary_author = el_summary_author;
    yy += el_summary_author.height + spacing;
    
    var el_summary_summary = create_text(c2 + 16, yy - 8, "", ew, eh, fa_left, ew, dg);
    el_summary_summary.valignment = fa_top;
    dg.el_summary_summary = el_summary_summary;
    yy += el_summary_summary.height + spacing;
    
    var el_new = create_button(dw /2 - b_width / 2, dh - 32 - b_height / 2, "Create New", b_width, b_height, fa_center, dmu_dialog_commit, dg);
    el_new.tooltip = "New maps will be created with a default white directional light with a vector of (-1, -1, -1).";
    
    ds_list_add(dg.contents,
        el_list,
        el_load,
        el_remove,
        el_other,
        el_summary,
        el_summary_name,
        el_summary_summary,
        el_summary_author,
        el_summary_timestamp_date,
        el_summary_timestamp_time,
        el_new
    );
    
    return dg;
}