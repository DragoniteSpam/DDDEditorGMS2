/// @param [name]

var name = (argument_count > 0) ? argument[0] : "";

return get_save_filename("DDD game data files|*" + EXPORT_EXTENSION_DATA, name);