/// @description  DataEventNode event_seek_node();
// Checks to see if there's a node under the mouse position

for (var i=0; i<ds_list_size(Stuff.active_event.nodes); i++){
    var node=Stuff.active_event.nodes[| i];
    if (mouse_within_rectangle_view(node.x, node.y, node.x+EVENT_NODE_CONTACT_WIDTH, node.y+EVENT_NODE_CONTACT_HEIGHT)){
        if (!node.is_root){
            return node;
        }
    }
}

return noone;
