/// @param MenuElement

var menu = argument0;

editor_mode_3d();
menu_activate(noone);
var dialog = dialog_create_data_types(noone);
dialog_create_notice(dialog, "There is no Undo button. Modifying game data is a permanent action, and deleted types or properties will be lost forever!");