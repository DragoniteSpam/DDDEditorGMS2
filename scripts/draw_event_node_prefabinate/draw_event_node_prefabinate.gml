function draw_event_node_prefabinate(xx, yy, node) {
    var prefab = guid_get(node.prefab_guid);
    var offset = 24;
    
    var spr = prefab ? spr_event_prefab_break : spr_event_prefab;
    var index = 0;
    var index2 = 0;
    
    if (!dialog_exists()) {
        var tolerance = 12;
        if (mouse_within_rectangle_adjusted(xx - tolerance, yy - tolerance, xx + tolerance, yy + tolerance)) {
            if (prefab) {
                index = 1;
                if (Controller.release_left) {
                    var dialog = dialog_create_yes_or_no(noone, "Break the prefab connection? The data will not be changed, but you will no longer be able to revert.", function(button) {
                        button.root.node.prefab_guid = NULL;
                        button.root.commit(button.root);
                    });
                    dialog.node = node;
                }
                draw_tooltip(xx, yy + 16, "Break Prefab");
            } else {
                index = 1;
                if (Controller.release_left) {
                    dialog_create_event_save_prefab(noone, node);
                }
                draw_tooltip(xx, yy + 16, "Save Prefab");
            }
        } else {
            if (mouse_within_rectangle_adjusted(xx - offset - tolerance, yy - tolerance, xx - offset + tolerance, yy + tolerance)) {
                if (prefab) {
                    index2 = 1;
                    if (Controller.release_left) {
                        var dialog = dialog_create_yes_or_no(noone, "Revert the prefab? Any changes you have made will be lost.", function(button) {
                            var node = button.root.node;
                            var prefab = guid_get(node.prefab_guid);
                            // not all of the variables can change so we don't
                            // have TOO mcuh work to do (for the most part the
                            // only things you care about are the data and
                            // custom data lists)
                            ds_list_copy(node.data, prefab.data);
                            for (var i = 0; i < ds_list_size(node.custom_data); i++) {
                                ds_list_copy(node.custom_data[| i], prefab.custom_data[| i]);
                            }
                            button.root.commit(button.root);
                        });
                        dialog.node = node;
                    }
                    draw_tooltip(xx - offset, yy + 16, "Revert Prefab");
                }
            }
        }
    }
    
    draw_sprite(spr, index, xx, yy);
    
    if (prefab) {
        draw_sprite(spr_event_prefab_revert, index2, xx - offset, yy);
    }
}