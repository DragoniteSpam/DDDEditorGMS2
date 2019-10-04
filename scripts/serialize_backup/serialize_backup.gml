/// @param folder
/// @param filename
/// @param extension
/// @param original

var folder = argument0;
var filename = argument1;
var extension = argument2;
var original = argument3;

if (Stuff.setting_backups > 0) {
    // would totally index from zero but
    for (var i = Stuff.setting_backups - 1; i > 0; i--) {
        var oldname = folder + filename + "-" + string(i) + extension;
        var newname = folder + filename + "-" + string(i + 1) + extension;
        if (file_exists(oldname)) {
            if (file_exists(newname)) {
                file_delete(newname);
            }
            file_rename(oldname, newname);
        }
    }
    // this is typically done before the new file is created, so if you're
    // not overwriting something the copy will fail
    if (file_exists(original)) {
        file_copy(original, folder + filename + "-1" + extension);
    }
}
