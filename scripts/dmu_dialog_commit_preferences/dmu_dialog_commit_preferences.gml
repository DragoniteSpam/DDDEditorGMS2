/// @param UIThing

ini_open(DATA_INI);
ini_write_real("config", "color", Stuff.setting_color);
ini_write_real("config", "bezier", Stuff.setting_bezier_precision);
ini_write_real("config", "backups", Stuff.setting_backups);
ini_write_real("config", "autosave", Stuff.setting_autosave);
ini_write_real("config", "alphabetize", Stuff.setting_alphabetize_lists);
ini_write_real("config", "npc-speed", Stuff.setting_alphabetize_npc_animate_rate);
ini_write_real("config", "code-ext", Stuff.setting_code_extension);
ini_close();

script_execute(argument0.root.commit, argument0.root);