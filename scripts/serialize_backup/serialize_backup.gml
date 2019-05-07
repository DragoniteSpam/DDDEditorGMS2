/// @description  void serialize_backup(folder, filename, extension, original);
/// @param folder
/// @param  filename
/// @param  extension
/// @param  original

if (Stuff.setting_backups>0){
    // would totally index from zero but
    for (var i=Stuff.setting_backups-1; i>0; i--){
        var oldname=argument0+argument1+"-"+string(i)+argument2;
        var newname=argument0+argument1+"-"+string(i+1)+argument2;
        if (file_exists(oldname)){
            if (file_exists(newname)){
                file_delete(newname);
            }
            file_rename(oldname, newname);
        }
    }
    // this is typically done before the new file is created, so if you're
    // not overwriting something the copy will fail
    if (file_exists(argument3)){
        file_copy(argument3, argument0+argument1+"-1"+argument2);
    }
}
