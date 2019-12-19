/// @param MenuElement

var menu = argument0;

if (file_exists(LOCAL_STORAGE + "missing.txt")) {
    ds_stuff_open_local("missing.txt");
} else {
    dialog_create_notice(menu, "No missing assets currently known. (That's a good thing!)");
}