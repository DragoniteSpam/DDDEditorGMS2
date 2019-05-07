/// @description  void setting_save_string(section, key, value);
/// @param section
/// @param  key
/// @param  value
// wrapper for when you want to save a single configuration value

ini_open(DATA_INI);
ini_write_string(argument0, argument1, argument2);
ini_close();
