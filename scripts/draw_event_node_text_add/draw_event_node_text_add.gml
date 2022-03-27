function draw_event_node_text_add(x, y, node) {
    draw_sprite(spr_plus_minus, 0, x, y);
    
    var tolerance = 8;
    if (mouse_within_rectangle(x - tolerance, y - tolerance, x + tolerance, y + tolerance)) {
        draw_sprite(spr_plus_minus, 1, x, y);
        draw_tooltip(x, y + 16, "Add Text");
        if (Controller.release_left) {
            array_push(node.data, "Text line " + string(array_length(node.data)));
            array_push(node.outbound, NULL);
        }
    }
}