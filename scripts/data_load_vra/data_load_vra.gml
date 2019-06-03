/// @description void data_load_vra();

ini_open(DATA_INI);
vra_name=ini_read_string("important", "vrax", "");
ini_close();

if (file_exists(PATH_VRA+vra_name)) {
    data_load_vra_actually_thanks(PATH_VRA+vra_name);
} else if (string_length(vra_name)>0) {
    show_message("Did not find vrax (mesh) file, using the default one instead: "+vra_name);
    data_load_vra_actually_thanks("data\\vra\\assets.vrax");
} else {
    debug("no vrax defined");
}
