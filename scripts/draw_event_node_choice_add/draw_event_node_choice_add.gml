function draw_event_node_choice_add(x, y, node) {
    draw_sprite(spr_plus_minus, 0, x, y);
    var tolerance = 8;
    if (mouse_within_rectangle(x - tolerance, y - tolerance, x + tolerance, y + tolerance)) {
        draw_sprite(spr_plus_minus, 1, x, y);
        draw_tooltip(x, y + 16, "Add Option");
        if (Controller.release_left) {
            array_push(node.data, "Option " + string(array_length(node.data)));
            // insert at the second to last position so that the "default" outbound node stays where it is
            array_insert(node.outbound, array_length(node.outbound) - 1, NULL);
        }
    }
}