/// @param MenuElement

var menu = argument0;

// but only if you're already in the data editor mode
if (Stuff.mode == Stuff.data) {
    editor_mode_3d();
}

menu_activate(noone);
dialog_create_data_types(noone);