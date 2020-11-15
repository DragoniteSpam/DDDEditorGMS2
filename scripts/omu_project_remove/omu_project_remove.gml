function omu_project_remove(button) {
    var selected_project = ui_list_selection(button.root.el_list);
    if (selected_project + 1) {
        var project = button.root.el_list.entries[| selected_project];
        var dialog = dialog_create_yes_or_no(button, "Do you want to remove " + project + "? Its autosave files will be deleted, but any files you saved elsewhere on your computer will still be there and you will be able to re-load them later.", function(button) {
            var project = button.root.project;
            var list = Stuff.all_projects[? "projects"];
            var name = list[| project];
            ds_list_delete(list, project);
            ui_list_deselect(button.root.root.root.el_list);
            directory_destroy(PATH_PROJECTS + name);
            var buffer = buffer_create(32, buffer_grow, 1);
            buffer_write(buffer, buffer_text, json_encode(Stuff.all_projects));
            buffer_save_ext(buffer, "projects.json", 0, buffer_tell(buffer));
            buffer_delete(buffer);
            dialog_destroy();
        });
        dialog.project = selected_project;
    }
}