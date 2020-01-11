/// @param UIButton

var list = argument0;
var base_dialog = list.root;
var selection = ui_list_selection(base_dialog.el_list);
var constant = Stuff.all_game_constants[| selection];

if (constant) {
    dialog_create_constant_get_event_graph(base_dialog, constant);
}