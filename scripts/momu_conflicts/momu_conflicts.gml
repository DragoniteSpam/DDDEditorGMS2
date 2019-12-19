/// @param MenuElement

var menu = argument0;

if (file_exists(LOCAL_STORAGE + "conflicts.txt")) {
    ds_stuff_open_local("conflicts.txt");
} else {
    dialog_create_notice(menu, "No asset conflicts currently known. (That's a good thing!)");
}