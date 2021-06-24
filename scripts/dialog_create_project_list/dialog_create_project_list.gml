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
            var project = Stuff.all_projects.projects[selected_project];
            if (project.failed) {
                emu_dialog_notice("Unable to load the project: " + project.name);
            }
            dialog_destroy();
            project_load(project.id);
        }
    };
    
    var el_list = create_list(16, yy, "Recent Projects", "<no projects>", ew, eh, 10, function(list) {
        var selection = ui_list_selection(list);
        if (selection + 1) {
            var project = Stuff.all_projects.projects[selection];
            if (project.failed) {
                list.root.el_summary_name.text = "Name: " + project.name;
                list.root.el_summary_summary.text = "Summary: [c_red]failed to load";
                list.root.el_summary_author.text = "Author:";
                list.root.el_summary_timestamp_date.text = "Date Modified:";
                list.root.el_summary_timestamp_time.text = "Time Modified:";
            } else {
                if (project.legacy) {
                    list.root.el_summary_name.text = "Name: " + project.name;
                    list.root.el_summary_summary.text = "Summary: (legacy)";
                    list.root.el_summary_author.text = "Author: (legacy)";
                    list.root.el_summary_timestamp_date.text = "Date Modified: (legacy)";
                    list.root.el_summary_timestamp_time.text = "Time Modified: (legacy)";
                } else {
                    list.root.el_summary_name.text = "Name: " + project.name;
                    list.root.el_summary_summary.text = "Summary: " + project.summary;
                    list.root.el_summary_author.text = "Author: " + project.author;
                    list.root.el_summary_timestamp_date.text = "Date Modified: " + project.timestamp_major;
                    list.root.el_summary_timestamp_time.text = "Time Modified: " + project.timestamp_minor;
                }
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
            project_list[@ i] = { name: project_list[i], legacy: true, id: "", source: "", };
        }
        ds_list_add(el_list.entries, project_list[i].name);
    }
    el_list.tooltip = "Here's a list of projects you've worked on recently.";
    el_list.entries_are = ListEntries.STRINGS;
    el_list.ondoubleclick = f_project_load;
    dg.el_list = el_list;
    
    #region metadata
    var n_projects = array_length(project_list);
    
    for (var i = 0; i < n_projects; i++) {
        var project = project_list[i];
        try {
            project.failed = false;
            if (!project.legacy) {
                var path_new = PATH_PROJECTS + project.id + "/project" + EXPORT_EXTENSION_PROJECT;
                var yaml = snap_from_yaml(buffer_read_file(path_new));
                project.summary = yaml.summary;
                project.author = yaml.author;
                project.timestamp_major = string(yaml.date.year) + "-" + string(yaml.date.month) + "-" + string(yaml.date.day);
                project.timestamp_minor = string(yaml.date.hour) + ":" + string_pad(yaml.date.minute, "0", 2) + ":" + string_pad(yaml.date.second, "0", 2);
            }
        } catch (e) {
            project.failed = true;
            el_list.entries[| i] = "(" + el_list.entries[| i] + ")";
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
        emu_dialog_notice("I'm not sure what I want to do with this - I'll probably add a Compress Project Archive option at some point");
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
    
    var el_new = create_button(dw /2 - b_width / 2, dh - 32 - b_height / 2, "Create New", b_width, b_height, fa_center, function(button) {
        dialog_destroy();
        Game.meta.start.map = Stuff.map.active_map.GUID;
    }, dg);
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