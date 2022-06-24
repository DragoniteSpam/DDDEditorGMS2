function draw_event_node_delete(xx, yy, node) {
    draw_sprite(spr_event_delete, 0, xx, yy);
    
    if (!dialog_exists()) {
        var tolerance = 8;
        if (mouse_within_rectangle(xx - tolerance, yy - tolerance, xx + tolerance, yy + tolerance)) {
            draw_sprite(spr_event_delete, 1, xx, yy);
            if (Controller.release_left) {
                var dialog = emu_dialog_confirm(undefined, "Do you actually want to delete " + node.name + "?", function() {
                    self.root.node.Destroy();
                    self.root.Dispose();
                });
                dialog.node = node;
            }
            draw_tooltip(xx, yy + 16, "Delete Node");
        }
    }
}