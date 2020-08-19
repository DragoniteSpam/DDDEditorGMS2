/// @param UICheckbox
function uivc_check_view_grids(argument0) {

    var checkbox = argument0;

    Stuff.setting_view_grid = checkbox.value;
    setting_set("View", "grid", Stuff.setting_view_grid);


}
