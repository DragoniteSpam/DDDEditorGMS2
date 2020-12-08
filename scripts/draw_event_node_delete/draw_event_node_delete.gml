function draw_event_node_delete(xx, yy, node) {
    draw_sprite(spr_event_delete, 0, xx, yy);
    
    if (!dialog_exists()) {
        var tolerance = 8;
        if (mouse_within_rectangle_adjusted(xx - tolerance, yy - tolerance, xx + tolerance, yy + tolerance)) {
            draw_sprite(spr_event_delete, 1, xx, yy);
            if (Controller.release_left) {
                var dialog = dialog_create_yes_or_no(noone, "Do you actually want to delete " + node.name + "?", function(button) {
                    instance_destroy_later(button.root.node);
                    button.root.commit(button.root);
                });
                dialog.node = node;
            }
            draw_tooltip(xx, yy + 16, "Delete Node");
        }
    }
}