/// @param UIButton

var button = argument0;
var selection = ui_list_selection(button.root.el_list);
var constant = Stuff.all_game_constants[| selection];

if (constant) {
    dialog_create_constant_get_event_graph(button.root, constant);
}