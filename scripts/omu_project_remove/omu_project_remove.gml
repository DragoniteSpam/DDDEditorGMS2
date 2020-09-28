/// @param UIButton
function omu_project_remove(argument0) {

    var button = argument0;

    var selected_project = ui_list_selection(button.root.el_list);

    if (selected_project + 1) {
        var project = button.root.el_list.entries[| selected_project];
        var dialog = dialog_create_yes_or_no(button, "Do you want to remove " + project + "? Its autosave files will be deleted, but any files you saved elsewhere on your computer will still be there and you will be able to re-load them later.", omu_project_remove_confirm);
        dialog.project = selected_project;
    }


}
