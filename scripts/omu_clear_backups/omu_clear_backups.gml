/// @param UIButton

var button = argument0;

var n = 0;

for (var name = file_find_first(PATH_BACKUP + "*.ddd*", 0); name != ""; name = file_find_next()) {
    file_delete(PATH_BACKUP + name);
    n++;
}

file_find_close();

dialog_create_notice(button.root, (n > 0) ? string(n) + " backup files removed." : "No backup files to remove.");