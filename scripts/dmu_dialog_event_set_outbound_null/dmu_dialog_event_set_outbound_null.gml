/// @param UIButton

var button = argument0;

var node = button.root.node;
var index = button.root.index;

event_connect_node(node, noone, index, true);

dialog_destroy();