/// @param UIButton

var button = argument0;

var selection = ui_list_selection(button.root.el_list);
var destination = button.root.el_list.entries[| selection];

if (destination) {
    var node = button.root.node;
    var index = button.root.index;
    
    event_connect_node(node, destination, index);
}

dialog_destroy();
dialog_destroy();