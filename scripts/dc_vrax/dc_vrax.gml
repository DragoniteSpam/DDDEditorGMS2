/// @description void dc_vrax(Dialog);
/// @param Dialog

var map=argument0.data;

// these have to exist
var vra_path=map[? "vra_path"];
var fn=map[? "fn"];

// use argument0.root because we need to talk to the meshes dialog,
// not the confirmation one (which is this)
data_load_vra_on_the_fly(argument0.root, vra_path, fn);

dialog_destroy();
