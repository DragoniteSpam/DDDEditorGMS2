/// @author JujuAdams
function ds_stuff_registry() {

	var path = parameter_string(0);
	var path = string_replace_all(path, "\\", "\\\\");
	var path = string_replace_all(path, "/", "\\\\");

	var ext = "dddm";
	var prog = "DDD.dddm";

	var out = "Windows Registry Editor Version 5.00";
	out +=  "\r\n";
	//out +=  "\r\n[HKEY_CLASSES_ROOT\\" + prog + "]";
	out +=  "\r\n[HKEY_CLASSES_ROOT\\" + ext + "]";
	out +=  "\r\n@=\"URL:" + ext + " Protocol\"";
	out +=  "\r\n\"URL Protocol\"=\"\"";
	out +=  "\r\n";
	out +=  "\r\n[HKEY_CLASSES_ROOT\\" + ext + "\\DefaultIcon]";
	out +=  "\r\n@=\"" + game_project_name + ".exe\"";
	out +=  "\r\n";
	out +=  "\r\n[HKEY_CLASSES_ROOT\\" + ext + "\\shell]";
	out +=  "\r\n";
	out +=  "\r\n[HKEY_CLASSES_ROOT\\" + ext + "\\shell\\open]";
	out +=  "\r\n";
	out +=  "\r\n[HKEY_CLASSES_ROOT\\" + ext + "\\shell\\open\\command]";
	out +=  "\r\n@=\"\\\"" + path + "\\\" \\\"%1\\\"\"";

	var file_reg = "uri_registration.reg";
	var file_bat = "uri_registration.bat";

	var f = buffer_create(1, buffer_grow, 1);
	buffer_write(f, buffer_text, out);
	buffer_save_ext(f, file_reg, 0, buffer_tell(f));
	buffer_delete(f);

	var bat = buffer_create(1, buffer_grow, 1);
	buffer_write(bat, buffer_text, "REGEDIT.EXE /S %~dp0\\uri_registration.reg");
	buffer_save_ext(bat, file_bat, 0, buffer_tell(f));
	buffer_delete(bat);

	ds_stuff_open(file_bat);

	/*
	string_save("uri_registration.reg", out);
	string_save("uri_registration.bat", "REGEDIT.EXE /S %~dp0\\uri_registration.reg");
	*/

	/*
	var _func = external_define("GMS-WinDev.dll", "shell_execute", dll_cdecl, ty_real, 2, ty_string, ty_string);
	external_call(_func, game_save_id + "uri_registration.bat", "");
	external_free("GMS-WinDev.dll");
	*/


}
