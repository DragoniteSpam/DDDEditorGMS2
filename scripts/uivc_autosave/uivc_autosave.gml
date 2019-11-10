/// @param UICheckbox

var checkbox = argument0;

Stuff.setting_autosave = checkbox.value;
setting_set("Config", "autosave", Stuff.setting_autosave);