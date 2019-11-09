/// @description DataEventNode event_seek_node();
// Checks to see if there's a node under the mouse position

for (var i=0; i<ds_list_size(Stuff.event.active.nodes); i++) {
    var node=Stuff.event.active.nodes[| i];
    if (mouse_within_rectangle_adjusted(node.x, node.y, node.x+EVENT_NODE_CONTACT_WIDTH, node.y+EVENT_NODE_CONTACT_HEIGHT)) {
        if (!node.is_root) {
            return node;
        }
    }
}

return noone;
