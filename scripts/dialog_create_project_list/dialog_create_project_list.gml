function dialog_create_project_list() {
    var dialog = new EmuDialog(640, 512, "Projects");
    dialog.flags |= DialogFlags.NO_CLOSE_BUTTON;
    dialog.contents_interactive = true;
    
    var col1x = 32;
    var col2x = dialog.width / 2 + 32;
    var element_width = 256;
    var element_height = 32;
    
    #region metadata
    var n_projects = array_length(Stuff.all_projects.projects);
    
    for (var i = 0, n = array_length(Stuff.all_projects.projects); i < n; i++) {
        var project = Stuff.all_projects.projects[i];
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
            project.name = "(" + project.name + ")";
            project.failed = true;
        }
    }
    #endregion
    
    dialog.AddContent([
        (new EmuList(col1x, EMU_AUTO, element_width, element_height, "Projects", element_height, 10, function() {
            if (!self.GetSibling("PROJECT NAME")) return;
            var selection = self.GetSelection();
            
            if (selection + 1) {
                var project = Stuff.all_projects.projects[selection];
                if (project.failed) {
                    self.GetSibling("PROJECT NAME").text = "Name: " + project.name;
                    self.GetSibling("PROJECT SUMMARY").text = "Summary: [c_red]failed to load";
                    self.GetSibling("PROJECT AUTHOR").text = "Author:";
                    self.GetSibling("PROJECT DATE").text = "Date Modified:";
                    self.GetSibling("PROJECT TIME").text = "Time Modified:";
                } else {
                    if (project.legacy) {
                        self.GetSibling("PROJECT NAME").text = "Name: " + project.name;
                        self.GetSibling("PROJECT SUMMARY").text = "Summary: (legacy)";
                        self.GetSibling("PROJECT AUTHOR").text = "Author: (legacy)";
                        self.GetSibling("PROJECT DATE").text = "Date Modified: (legacy)";
                        self.GetSibling("PROJECT TIME").text = "Time Modified: (legacy)";
                    } else {
                        self.GetSibling("PROJECT NAME").text = "Name: " + project.name;
                        self.GetSibling("PROJECT SUMMARY").text = "Summary: " + project.summary;
                        self.GetSibling("PROJECT AUTHOR").text = "Author: " + project.author;
                        self.GetSibling("PROJECT DATE").text = "Date Modified: " + project.timestamp_major;
                        self.GetSibling("PROJECT TIME").text = "Time Modified: " + project.timestamp_minor;
                    }
                }
            } else {
                self.GetSibling("PROJECT NAME").text = "";
                self.GetSibling("PROJECT SUMMARY").text = "";
                self.GetSibling("PROJECT AUTHOR").text = "";
                self.GetSibling("PROJECT DATE").text = "";
                self.GetSibling("PROJECT TIME").text = "";
            }
        }))
            .SetEntryTypes(E_ListEntryTypes.STRUCTS)
            .SetList(Stuff.all_projects.projects)
            .SetCallbackDouble(function() {
                var selection = self.GetSelection();
                if (selection + 1) {
                    var project = Stuff.all_projects.projects[selection];
                    if (project.failed) {
                        emu_dialog_notice("Unable to load the project: " + project.name);
                    }
                    project_load(project.id);
                    self.root.Dispose();
                }
            })
            .SetID("LIST"),
        (new EmuButton(col1x, EMU_AUTO, element_width, element_height, "Delete Project", function() {
            var selected_project = self.GetSibling("LIST").GetSelection();
            if (selected_project + 1) {
                var project = Stuff.all_projects.projects[selected_project];
                var dialog = emu_dialog_confirm(self, "Do you want to remove " + project.name + "?", function() {
                    var project = Stuff.all_projects.projects[self.root.project];
                    array_delete(Stuff.all_projects.projects, self.root.project, 1);
                    self.root.root.GetSibling("LIST").Deselect();
                    directory_destroy(PATH_PROJECTS + project.name);
                    buffer_write_file(json_stringify(Stuff.all_projects), "projects.json");
                    self.root.Dispose();
                });
                dialog.project = selected_project;
            }
        })),
        (new EmuText(col2x, EMU_BASE, element_width, element_height, ""))
            .SetAlignment(fa_left, fa_top)
            .SetID("PROJECT NAME"),
        (new EmuText(col2x, EMU_AUTO, element_width, element_height, ""))
            .SetAlignment(fa_left, fa_top)
            .SetID("PROJECT AUTHOR"),
        (new EmuText(col2x, EMU_AUTO, element_width, element_height, ""))
            .SetAlignment(fa_left, fa_top)
            .SetID("PROJECT DATE"),
        (new EmuText(col2x, EMU_AUTO, element_width, element_height, ""))
            .SetAlignment(fa_left, fa_top)
            .SetID("PROJECT TIME"),
        (new EmuText(col2x, EMU_AUTO, element_width, element_height * 10, ""))
            .SetAlignment(fa_left, fa_top)
            .SetID("PROJECT SUMMARY"),
    ])
        .AddDefaultConfirmCancelButtons("Open", function() {
            self.GetSibling("LIST").callback_double();
        }, "Create New", emu_dialog_close_auto);
}