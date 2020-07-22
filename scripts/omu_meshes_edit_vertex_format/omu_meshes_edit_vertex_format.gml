/// @param UIThing

var thing = argument0;
var list = thing.root.format_list;
var selection = ui_list_selection(list);

dialog_create_mesh_vertex_format_editor(thing, selection);