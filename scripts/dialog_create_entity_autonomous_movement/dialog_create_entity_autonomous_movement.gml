/// @param Dialog
function dialog_create_entity_autonomous_movement(argument0) {

    var dialog = argument0;

    var dw = 640;
    var dh = 640;

    // you can assume that this is valid data because this won't be called otherwise
    var list = Stuff.map.selected_entities;
    var entity = list[| 0];
    var dg = dialog_create(dw, dh, "Autonomous Movement", dialog_default, dialog_destroy, dialog);
    dg.entity = entity;

    var columns = 2;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;

    var col1_x = 0 * dw / columns + 16;
    var col2_x = 1 * dw / columns + 16;

    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;

    var yy = 64;
    var ucheck_width = 64;        // unlabeled check boxes shouldn't have as wide of a hitbox

    var el_movement = create_radio_array(col1_x, yy, "Autonomous Movement", ew, eh, uivc_entity_auto_move, entity.autonomous_movement, dg);
    create_radio_array_options(el_movement, ["Fixed", "Random", "Approach", "Custom"]);
    yy += el_movement.GetHeight() + spacing;

    var el_movement_speed = create_radio_array(col1_x, yy, "Move Speed", ew, eh, uivc_entity_auto_speed, entity.autonomous_movement_speed, dg);
    create_radio_array_options(el_movement_speed, ["1 / 8x", "1 / 4x", "1 / 2x", "1x", "2x", "4x"]);
    yy += el_movement_speed.GetHeight() + spacing;

    var el_movement_frequency = create_radio_array(col1_x, yy, "Move Frequency", ew, eh, uivc_entity_auto_frequency, entity.autonomous_movement_frequency, dg);
    create_radio_array_options(el_movement_frequency, ["Slowest", "Slow", "Normal", "Fast", "Fastest"]);
    yy += el_movement_frequency.GetHeight() + spacing;

    yy = 64;
    var n = 8;

    var el_move_routes = create_list(col2_x, yy, "Move Routes", "<No move routes>", ew, eh, n, null, false, dg, entity.movement_routes);
    el_move_routes.entries_are = ListEntries.INSTANCES;
    el_move_routes.ondoubleclick = omu_entity_edit_move_route;
    yy += el_move_routes.GetHeight() + spacing;
    dg.el_move_routes = el_move_routes;

    var el_move_route_edit = create_button(col2_x, yy, "Edit Move Route", ew, eh, fa_center, omu_entity_edit_move_route, dg);
    yy += el_move_route_edit.height + spacing;

    var el_move_route_add = create_button(col2_x, yy, "Add Move Route", ew, eh, fa_center, omu_entity_add_move_route, dg);
    yy += el_move_route_add.height + spacing;

    var el_move_route_delete = create_button(col2_x, yy, "Delete Move Route", ew, eh, fa_center, omu_entity_remove_move_route, dg);
    yy += el_move_route_delete.height+spacing;

    var el_move_route_auto = create_button(col2_x, yy, "Set Auto", ew / 2, eh, fa_center, omu_entity_set_auto_move_route, dg);
    var el_move_route_auto_remove = create_button(col2_x + ew / 2, yy, "Delete Auto", ew / 2, eh, fa_center, omu_entity_remove_auto_move_route, dg);
    yy += el_move_route_auto_remove.height + spacing;

    var b_width = 128;
    var b_height = 32;
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

    ds_list_add(dg.contents,
        el_movement,
        el_movement_speed,
        el_movement_frequency,
        el_move_routes,
        el_move_route_edit,
        el_move_route_add,
        el_move_route_delete,
        el_move_route_auto,
        el_move_route_auto_remove,
        el_confirm
    );

    return dg;


}
