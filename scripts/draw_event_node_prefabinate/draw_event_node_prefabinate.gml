/// @param x
/// @param y
/// @param DataEventNode

var xx = argument0;
var yy = argument1;
var node = argument2;
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
                var dialog = dialog_create_yes_or_no(noone, "Break the prefab connection? The data will not be changed, but you will no longer be able to revert.", dmu_dialog_event_break_prefab);
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
                    var dialog = dialog_create_yes_or_no(noone, "Revert the prefab? Any changes you have made will be lost.", dmu_dialog_event_revert_prefab);
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