/// @param UICheckbox
function uivc_check_view_grids(argument0) {

    var checkbox = argument0;

    Settings.view.grid = checkbox.value;
    setting_set("View", "grid", Settings.view.grid);


}
