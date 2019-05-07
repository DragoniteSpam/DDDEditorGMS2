/// @description  double ds_stuff_open_local(file);
/// @param file

/*
 * Used for opening files in the game's local storage. For stuff in the
 * game's file bundle, see ds_stuff_open. (It also documents the return
 * codes and stuff.)
 *
 * When opening stuff with this script, don't pass it the leading dot
 * or the double backslash ("file.txt" isntead of ".\\file.txt").
 */

return ds_stuff_open(environment_get_variable("localappdata")+"\\\\DDDEditor\\\\"+argument0);
