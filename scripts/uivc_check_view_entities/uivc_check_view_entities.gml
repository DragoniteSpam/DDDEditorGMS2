/// @param UICheckbox
function uivc_check_view_entities(argument0) {

    var checkbox = argument0;

    Settings.view.entities = checkbox.value;
    setting_set("View", "entities", Settings.view.entities);


}
