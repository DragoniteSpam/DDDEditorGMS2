/// @param UIButton
function uivc_move_route_delete(argument0) {

    var button = argument0;
    var entity = button.root.entity;
    var route = button.root.route;
    var index = array_search(entity.movement_routes, route);

    move_route_make_invisible(entity, route);
    array_delete(entity.movement_routes, index, 1);
    ui_list_deselect(button.root.root.el_move_routes);

    dialog_destroy(button);


}
