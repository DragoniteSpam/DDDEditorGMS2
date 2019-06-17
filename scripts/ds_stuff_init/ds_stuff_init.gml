var dll = "data\\stuff.dll";
var calltype = dll_cdecl;

global._ds_stuff_open = external_define(dll, "open", calltype, ty_real, 1, ty_string);
global._ds_stuff_edit = external_define(dll, "edit", calltype, ty_real, 1, ty_string);
global._ds_stuff_help = external_define(dll, "help", calltype, ty_real, 1, ty_string);
global._ds_stuff_copy = external_define(dll, "copy", calltype, ty_real, 2, ty_string, ty_string);
global._ds_stuff_process_complete = external_define(dll, "process_complete", calltype, ty_real, 1, ty_real);
global._ds_stuff_kill = external_define(dll, "kill", calltype, ty_real, 1, ty_real);

global._ds_stuff_fetch_status = external_define(dll, "fetch_status", calltype, ty_real, 0);
global._ds_stuff_reset_status = external_define(dll, "reset_status", calltype, ty_real, 0);

external_call(external_define(dll, "init", calltype, ty_real, 1, ty_string), window_handle());