var dll = "data/drago.dll";
var calltype = dll_cdecl;

global._ds_stuff_open = external_define(dll, "open", calltype, ty_real, 1, ty_string);
global._ds_stuff_edit = external_define(dll, "edit", calltype, ty_real, 1, ty_string);
global._ds_stuff_copy = external_define(dll, "copy", calltype, ty_real, 2, ty_string, ty_string);
global._ds_stuff_process_complete = external_define(dll, "process_complete", calltype, ty_real, 1, ty_real);
global._ds_stuff_kill = external_define(dll, "kill", calltype, ty_real, 1, ty_real);
global._ds_stuff_process = external_define(dll, "process", calltype, ty_real, 2, ty_string, ty_string);

global._ds_stuff_fetch_status = external_define(dll, "fetch_status", calltype, ty_real, 0);
global._ds_stuff_reset_status = external_define(dll, "reset_status", calltype, ty_real, 0);

global._ds_stuff_file_drop_count = external_define(dll, "file_drop_count", calltype, ty_real, 0);
global._ds_stuff_file_drop_get = external_define(dll, "file_drop_get", calltype, ty_string, 1, ty_real);
global._ds_stuff_file_drop_flush = external_define(dll, "file_drop_flush", calltype, ty_real, 0);

global._ds_stuff_pack_textures = external_define(dll, "pack_textures", calltype, ty_real, 3, ty_real, ty_real, ty_real);

external_call(external_define(dll, "init", calltype, ty_real, 2, ty_string, ty_real), window_handle(), true);

function ds_stuff_pack_textures(addr, length) {
    return external_call(global._ds_stuff_pack_textures, addr, length, 0);
}

function ds_stuff_copy(source, destination) {
    // Copies a file from the source to the destination
    return external_call(global._ds_stuff_copy, source, destination);
}

function ds_stuff_edit(file) {
    // returns the ID of the process
    return external_call(global._ds_stuff_edit, file);
}

function ds_stuff_edit_local(file) {
    // returns the ID of the process
    /*
     * Used for editing files in the game's local storage. For stuff in the
     * game's file bundle, see ds_stuff_open. (It also documents the return
     * codes and stuff.)
     *
     * When opening stuff with this script, don't pass it the leading dot
     * or the double backslash ("file.txt" isntead of "./file.txt").
     */
    return ds_stuff_edit(LOCAL_STORAGE + file);
}

function ds_stuff_fetch_dropped_files() {
    var n = external_call(global._ds_stuff_file_drop_count);
    var array = array_create(n);
    
    for (var i = 0; i < n; i++) {
        array[i] = external_call(global._ds_stuff_file_drop_get, i);
    }
    
    array_sort(array, true);
    
    external_call(global._ds_stuff_file_drop_flush);
    return array;
}

#macro WINDOW_NEVERMIND 0
#macro WINDOW_CLOSE 1

function ds_stuff_fetch_status() {
    return external_call(global._ds_stuff_fetch_status);
}

function ds_stuff_kill(file) {
    return external_call(global._ds_stuff_kill, file);
}

function ds_stuff_open(file) {
    // returns the ID of the process, or 0
    if (!file_exists(file)) return false;
    return external_call(global._ds_stuff_open, file);
}

#macro LOCAL_STORAGE environment_get_variable("localappdata") + "/" + game_project_name + "/"

function ds_stuff_open_local(file) {
    /*
     * Used for opening files in the game's local storage. For stuff in the
     * game's file bundle, see ds_stuff_open. (It also documents the return
     * codes and stuff.)
     *
     * When opening stuff with this script, don't pass it the leading dot
     * or the double backslash ("file.txt" isntead of "./file.txt").
     */
    
    return ds_stuff_open(LOCAL_STORAGE + file);
}

function ds_stuff_process_complete(file) {
    return external_call(global._ds_stuff_process_complete, file);
}

function ds_stuff_reset_status() {
    return external_call(global._ds_stuff_reset_status);
}

function ds_stuff_shell_execute(verb, file) {
    // returns the ID of the process
    // the arguments go in reverse order because that's how it was set up way back when
    return external_call(global._ds_stuff_process, file, verb);
}