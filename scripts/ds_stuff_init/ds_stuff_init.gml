var dll = "data\\stuff.dll";
var calltype = dll_cdecl;

global._ds_stuff_open = external_define(dll, "open", calltype, ty_real, 1, ty_string);
global._ds_stuff_exit = external_define(dll, "edit", calltype, ty_real, 1, ty_string);
global._ds_stuff_help = external_define(dll, "help", calltype, ty_real, 1, ty_string);
global._ds_stuff_copy = external_define(dll, "copy", calltype, ty_real, 2, ty_string, ty_string);
global._ds_stuff_copy = external_define(dll, "process_complete", calltype, ty_real, 1, ty_real);